require 'octokit'
require 'optparse'
require 'optparse/time'
require 'date'
require './commit-measure/main.rb'

options = {}
OptionParser.new do |opts|
  opts.on("-r", "--repository URL") do |arg|
    options[:repository] = arg
  end

  opts.on("--start", "--start-date DATE", Time) do |arg|
    options[:start_date] = arg
  end

  opts.on("--end", "--end-date DATE", Time) do |arg|
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
client.methods.each do |method|
  puts method if method.to_s.index('url')
end

# Reject drafts
pull_requests = pull_requests.reject(&:draft) unless options[:drafts]

# Limit to date range
pull_requests = pull_requests.select { |pr| options[:start_date] <= pr.created_at } if options[:start_date]
pull_requests = pull_requests.select { |pr| options[:end_date] >= pr.created_at } if options[:end_date]
pull_requests.first.methods.each do |method|
  puts method if method.to_s.index('commit')
end
#output = {}

#repo_path = clone(options[:repository])

pull_requests.each do |pr|
  puts pr.title, pr.number, pr.closed_at, pr.created_at, pr.commits_url
  response = client.get(pr.commits_url)
  puts response.to_s 
end

#[:to_h, :include?, :at, :fetch, :last, :union, :difference, :intersection, :push, :append, :pop, :shift, :unshift, :each_index, :join, :rotate, :rotate!, :sort!, :sort_by!, :collect!, :map!, :select!, :filter!, :keep_if, :values_at, :delete_at, :delete_if, :reject!, :transpose, :fill, :assoc, :rassoc, :uniq!, :compact, :*, :+, :flatten, :-, :&, :flatten!, :compact!, :combination, :repeated_permutation, :permutation, :product, :bsearch, :repeated_combination, :sort, :bsearch_index, :deconstruct, :count, :find_index, :select, :filter, :reject, :collect, :map, :first, :all?, :any?, :one?, :none?, :minmax, :reverse_each, :zip, :take, :take_while, :drop, :|, :cycle, :drop_while, :sum, :uniq, :<=>, :<<, :insert, :==, :index, :[], :[]=, :replace, :rindex, :clear, :empty?, :eql?, :max, :min, :inspect, :reverse, :reverse!, :concat, :prepend, :length, :size, :each, :to_ary, :to_a, :to_s, :delete, :slice, :slice!, :pack, :shuffle!, :shuffle, :sample, :dig, :hash, :to_json, :slice_after, :slice_when, :chunk_while, :chain, :lazy, :to_set, :find, :entries, :sort_by, :grep, :grep_v, :detect, :find_all, :filter_map, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :tally, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :each_entry, :each_slice, :each_cons, :each_with_object, :chunk, :slice_before, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :method, :public_method, :public_send, :singleton_method, :gem, :define_singleton_method, :extend, :to_enum, :enum_for, :===, :=~, :!~, :nil?, :respond_to?, :freeze, :object_id, :send, :display, :frozen?, :class, :then, :tap, :yield_self, :singleton_class, :dup, :itself, :!, :!=, :__id__, :equal?, :instance_eval, :instance_exec, :__send__]
#pull_requests.map(&:number).each do |prn|
#  commits = client.pull_request_commits(options[:repository], prn)
#  commits = commits.select { |c| c.author&.type == 'User' } unless options[:bots]
#  commit_hashes = commits.map(&:sha)
#
#  pr = PullRequest.new(repo_path, commit_hashes)
#  output[prn] = pr.stats.values.join(",")
#end
#
#puts output.values.join("\n")
