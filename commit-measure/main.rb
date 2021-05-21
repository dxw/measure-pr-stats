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

  files_changed = /(\d)+ files changed/.match(stats)&.captures[0].to_i || 0
  insertions = /(\d)+ insertions/.match(stats)&.captures[0].to_i || 0
  deletions = /(\d)+ deletions/.match(stats)&.captures[0].to_i || 0

  {
    files_changed: files_changed,
    insertions: insertions,
    deletions: deletions
  }
end

def sum_all_changes(repo_path, commit_hashes)
  commit_hashes.map { |commit_hash|
    count_changes(repo_path, commit_hash)
  }.reduce { |acc, result|
    {
      files_changed: acc[:files_changed] + result[:files_changed],
      insertions: acc[:insertions] + result[:insertions],
      deletions: acc[:deletions] + result[:deletions]
    }
  }
end

def calculate_change_statistics(repo_path, commit_hashes)
  changes = sum_all_changes(repo_path, commit_hashes)

  total = changes[:insertions] + changes[:deletions]

  {
    total: total,
    changes_per_commit: total / commit_hashes.length
  }
end

repo_name = ARGV[0]

repo_path = clone(repo_name)

commit_hashes = [ARGV[1], ARGV[1], ARGV[1]]

p calculate_change_statistics(repo_path, commit_hashes)
