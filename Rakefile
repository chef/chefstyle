# frozen_string_literal: true
require "bundler/gem_tasks"

require "chefstyle"
require "rubocop/rake_task"
RuboCop::RakeTask.new(:style) do |task|
  task.options << "--display-cop-names"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList["spec/cop/**/*.rb"]
end

desc "Run RSpec with code coverage"
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].execute
end

desc "Ensure that all cops are defined in the chefstyle.yml config"
task :validate_config do
  require "chefstyle"
  require "yaml" unless defined?(YAML)
  status = 0
  config = YAML.load_file("config/chefstyle.yml")

  puts "Checking that all cops are defined in config/chefstyle.yml:"

  RuboCop::Cop::Chef.constants.each do |dep|
    RuboCop::Cop::Chef.const_get(dep).constants.each do |cop|
      unless config["Chef/#{dep}/#{cop}"]
        puts "Error: Chef/#{dep}/#{cop} not found in config/chefstyle.yml"
        status = 1
      end
    end
  end

  puts "All Cops found in the config. Good work." if status == 0

  exit status
end

task :console do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end
task default: %i{style spec validate_config}
