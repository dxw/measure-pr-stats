require 'octokit'
require 'optparse'
require 'optparse/date'
require 'date'

#repo_name = "dxw/project-wisdom"

options = {}
OptionParser.new do |opts|
  opts.on("-r", "--repository URL") do |arg|
    options[:repository] = arg
  end

  opts.on("--start", "--start-date DATE", DateTime) do |arg|
    options[:start_date] = arg
  end

  opts.on("--end", "--end-date DATE", DateTime) do |arg|
    options[:end_date] = arg
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

client = Octokit::Client.new(access_token: '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')

pull_requests = client.pull_requests(options[:repository], state: options[:state])

# Reject drafts
pull_requests = pull_requests.reject(&:draft) unless options[:drafts]

# 
output = {}

pull_requests.map(&:number).each do |prn|
  commits = client.pull_request_commits(options[:repository], prn)

  commits = commits.select { |c| c.author.type == 'User' } unless options[:bots]

  output[prn] = commits.map(&:sha) unless commits.empty?
  # do something with commits
end

puts output