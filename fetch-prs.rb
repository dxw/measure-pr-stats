require 'json'

graphql_query = <<-GRAPHQL
query ($endCursor: String, $repoName: String!) {
  repository(name: $repoName, owner: "dxw") {
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
              committedDate
              authoredDate
              messageHeadline
            }
          }
        }
      }
    }
  }
}
GRAPHQL

`gh api graphql -f query='#{graphql_query}' -f repoName='rails-template' --paginate > pr.json`
#x = `gh api graphql -f query='#{graphql_query}' -f repoName='rails-template' --paginate`
#json = JSON.parse(x)
# require 'pry';binding.pry
