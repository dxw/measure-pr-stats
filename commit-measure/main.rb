require 'git'
require 'logger'

ARGV

# test command
# bundle exec ruby commit-meaure/main.rb dxw/rails-template 405a44fbfff17d014c0098065f3539800704f065

repo_name = ARGV[0]
commit_hash = ARGV[1]

`rm -r -f tmp`

g = Git.clone("https://github.com/#{repo_name}", repo_name, path: "tmp", log: Logger.new(STDOUT))




# length of commit message
# files created/deleted/renamed

# number of changes: lines add/lines removed, files modified

# git show --format="" --shortstat 4ad4b8fc3dc34ae83b4af1e41746f5a844935966
Dir.chdir("tmp/#{repo_name}")

puts `git show --format="" --shortstat #{commit_hash}`
