require 'octokit'
require 'optparse'
require 'optparse/time'
require 'date'
require 'json'
require 'dotenv'
Dotenv.load

options = {}
OptionParser.new do |opts|
  opts.on('-r', '--repository URL') do |arg|
    options[:repository] = arg.gsub('https://github.com/', '')
  end

  opts.on('--start', '--start-date DATE', Time) do |arg|
    options[:start_date] = arg
  end

  opts.on('--end', '--end-date DATE', Time) do |arg|
    options[:end_date] = arg
  end

  opts.on('--state STATE') do |arg|
    options[:state] = arg
  end

  opts.on('--drafts DRAFTS', FalseClass) do |arg|
    options[:drafts] = arg
  end

  opts.on('--bots BOTS', FalseClass) do |arg|
    options[:bots] = arg
  end

  opts.on('--token TOKEN') do |arg|
    options[:token] = arg
  end
end.parse!

# Use default options
options = {
  state: 'closed',
  token: ENV.fetch('GITHUB_TOKEN', nil)
}.merge(options)

############
client = Octokit::Client.new(access_token: options[:token])

# Get last 300 pull requests
pull_requests = []
page = 1;
loop do
  resp = client.pull_requests(options[:repository], state: options[:state], per_page: 100, page: page)
  pull_requests += resp
  page += 1
  break if page > 3
end

# Reject drafts
pull_requests = pull_requests.reject(&:draft) unless options[:drafts]

# Limit to date range
pull_requests = pull_requests.select { |pr| options[:start_date] <= pr.created_at } if options[:start_date]
pull_requests = pull_requests.select { |pr| options[:end_date] >= pr.created_at } if options[:end_date]
pull_requests = pull_requests.select { |pr| pr.user.type == 'User' } unless options[:bots]

#############
output = []

pull_requests.each do |pr|
  commits = client.pull_request_commits(options[:repository], pr.number)
  reviews = client.pull_request_reviews(options[:repository], pr.number)
  comments = client.pull_request_comments(options[:repository], pr.number)

  total_lines_added = 0
  total_lines_deleted = 0
  total_message_length = 0
  total_number_of_files= 0
  commits.each do |commit|
    commit = client.commit(options[:repository], commit.sha)
    total_message_length += commit.commit.message.split(' ').length
    total_lines_added += commit.stats.additions
    total_lines_deleted += commit.stats.deletions
    total_number_of_files += commit.files.length
  end

  output << {
    url: pr.url,
    prn: pr.number,
    created_at: pr.created_at,
    closed_at: pr.closed_at,
    number_of_commits: commits.length,
    number_of_files: total_number_of_files,
    number_of_reviewers: reviews.select{ |r| r.state == 'APPROVED' }.length,
    number_of_comments: comments.length,
    avg_commit_message_word_count: total_message_length/commits.length,
    total_lines_added: total_lines_added,
    total_lines_deleted: total_lines_deleted,
    total_lines_changed: total_lines_added + total_lines_deleted,
    pr_message_word_count: pr.body.split(' ').length
  }
end

File.write("output/#{options[:repository].gsub('/', '_')}.json", output.group_by { |pr| pr[:created_at].strftime('%Y-%m') }.to_json)