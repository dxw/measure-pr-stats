require 'octokit'
require 'optparse'
require 'date'
require './commit-measure/main.rb'

#repo_name = "dxw/project-wisdom"

options = {}
OptionParser.new do |opts|
  opts.on("-r", "--repository URL") do |arg|
    options[:repository] = arg
  end

  opts.on("--state STATE") do |arg|
    options[:state] = arg || 'open'
  end

  opts.on("--drafts DRAFTS", FalseClass) do |arg|
    options[:drafts] = arg
  end

  opts.on("--bots BOTS", FalseClass) do |arg|
    options[:bots] = arg
  end
end.parse!

client = Octokit::Client.new()

pull_requests = client.pull_requests(options[:repository], state: options[:state])

# Reject drafts
pull_requests = pull_requests.reject(&:draft) unless options[:drafts]

#
output = {}

repo_path = clone(options[:repository])

pull_requests.map(&:number).each do |prn|
  commits = client.pull_request_commits(options[:repository], prn)

  commits = commits.select { |c| c.author.type == 'User' } unless options[:bots]

  commit_hashes = commits.map(&:sha)

  pr = PullRequest.new(repo_path, commit_hashes)

  output[prn] = pr.stats
end

puts output
