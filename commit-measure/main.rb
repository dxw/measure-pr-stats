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

repo_name = ARGV[0]
commit_hash = ARGV[1]

repo_path = "tmp/repos/#{repo_name}"

`rm -r -f tmp`

`git clone "https://github.com/#{repo_name}" #{repo_path}`
Dir.chdir(repo_path)

puts `git show --format="" --shortstat #{commit_hash}`
