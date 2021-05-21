# To execute:
# bundle exec ruby commit-measure/main.rb dxw/rails-template 405a44fbfff17d014c0098065f3539800704f065

# To measure:
# - code changes count
#   - lines added
#   - lines removed
#   - files modified
# - length of commit message
# - file changes count
#   - created
#   - deleted
#   - renamed
# - number of merge commits

def clone(repo_name)
  repo_path = "tmp/repos/#{repo_name}"

  `rm -r -f tmp`

  `git clone "https://github.com/#{repo_name}" #{repo_path}`

  repo_path
end

def count_changes(repo_path, commit_hash)
  stats = `cd #{repo_path} && git show --format="" --shortstat #{commit_hash}`

  files_changed = /(\d)+ files changed/.match(stats).captures[0]
  insertions = /(\d)+ insertions/.match(stats).captures[0]
  deletions = /(\d)+ deletions/.match(stats).captures[0]

  {
    files_changed: files_changed,
    insertions: insertions,
    deletions: deletions
  }
end

repo_name = ARGV[0]
commit_hash = ARGV[1]

repo_path = clone(repo_name)
p count_changes(repo_path, commit_hash)
