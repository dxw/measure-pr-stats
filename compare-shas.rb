require 'json'

def commits_between(org: "dxw", repo:, old_sha:, new_sha:)
  raw_diff = `gh api -X GET "/repos/#{org}/#{repo}/compare/#{old_sha}...#{new_sha}"`
  JSON.parse(raw_diff)["commits"].map { |c| c["sha"] }
end

# puts commits_between(
#   org: "UKGovernmentBEIS",
#   repo: "beis-report-official-development-assistance",
#   old_sha: "2902af67", new_sha: "3d7df180"
# )
