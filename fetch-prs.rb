require 'json'
require 'pry'
require 'date'

owner = 'UKGovernmentBEIS'
repoName = 'beis-report-official-development-assistance'

graphql_query = <<-GRAPHQL
query ($endCursor: String, $owner: String!, $repoName: String!) {
  repository(name: $repoName, owner: $owner) {
    pullRequests(
      states: MERGED
      first: 25
      after: $endCursor
      orderBy: { field: CREATED_AT, direction: DESC }
    ) {
      totalCount
      pageInfo {
        endCursor
        hasNextPage
      }
      nodes {
        number
        title
        author {
          login
        }
        state
        mergeCommit {
          oid
          authoredDate
        }
        publishedAt
        mergedAt
        commits(first: 50) {
          nodes {
            commit {
              oid
              authoredDate
            }
          }
        }
      }
    }
  }
}
GRAPHQL

owner = 'UKGovernmentBEIS'
repoName = 'beis-report-official-development-assistance'

graphql_output=`gh api graphql -f query='#{graphql_query}' -f repoName='#{repoName}' -f owner='#{owner}' --paginate --cache='1h' | jq ".[].repository.pullRequests.nodes" | jq ".[]" | jq -s .`
# print(graphql_output)

# `git rev-list #{old}..#{new}`

raw_pr_data = JSON.parse(graphql_output)

commit_info = {}

raw_pr_data.each do |pr|
  next if pr["commits"]["nodes"].nil? || pr["commits"]["nodes"].empty?

  work_started_date = pr["commits"]["nodes"].map { | node| node["commit"]["authoredDate"] }.sort.first
  commit_shas = pr["commits"]["nodes"].map { | node| node["commit"]["oid"] }
  worked_merged_date = pr["mergedAt"]
  pr_data = {
    pr_number: pr["number"],
    work_started_date: work_started_date,
    worked_merged_date: worked_merged_date,
  }

  commit_shas.each do |c|
    if commit_info.key?(c)
      commit_info[c] << pr_data
      puts "NINO NINO #{c}"
    else
      commit_info[c] = [pr_data]
    end
  end
end

commit_info.each do |k, v|
  puts "Commit #{k} : #{v}"
end

