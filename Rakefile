require "bundler/gem_tasks"

upstream = Gem::Specification.find_by_name("rubocop")

desc "Vendor rubocop-#{upstream.version} configuration into gem"
task :vendor do
  src = Pathname.new(upstream.gem_dir).join("config")
  dst = Pathname.new(__FILE__).dirname.join("config")

  mkdir_p dst
  cp(src.join("default.yml"), dst.join("upstream.yml"))

  require "rubocop"
  require "yaml"
  cfg = RuboCop::Cop::Cop.all.inject({}) { |acc, cop| acc[cop.cop_name] = { "Enabled" => false }; acc }
  File.open(dst.join("disable_all.yml"), "w") { |fh| fh.write cfg.to_yaml }

  sh %{git add #{dst}/{upstream,disable_all}.yml}
  sh %{git commit -m "Vendor rubocop-#{upstream.version} upstream configuration."}
end

require "chefstyle"
require "rubocop/rake_task"
RuboCop::RakeTask.new(:style) do |task|
  task.options << "--display-cop-names"
end

begin
  require "yard"
  YARD::Rake::YardocTask.new(:docs)
rescue LoadError
  puts "yard is not available. bundle install first to make sure all dependencies are installed."
end

task :console do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end
task default: %i{build install}
