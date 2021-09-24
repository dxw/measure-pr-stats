require 'json'

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
print(graphql_output)

# `git rev-list #{old}..#{new}`