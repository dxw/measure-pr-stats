require './commit-measure/main.rb'
:repository = 'UKGovernmentBEIS/beis-report-official-development-assistance'
repo_path = clone(options[:repository])

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
