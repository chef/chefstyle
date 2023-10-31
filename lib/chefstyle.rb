# frozen_string_literal: true
require_relative "chefstyle/version"

# ensure the desired target version of RuboCop is gem activated
gem "rubocop", "= #{Chefstyle::RUBOCOP_VERSION}"
require "rubocop"

# Chefstyle patches the RuboCop tool to set a new default configuration that
# is vendored in the Chefstyle codebase.
module Chefstyle
  # @return [String] the absolute path to the main RuboCop configuration YAML file
  def self.config
    File.realpath(File.join(__dir__, "..", "config", "default.yml"))
  end
end

require_relative "rubocop/chef"

# Chef custom cops
Dir.glob(__dir__ + "/rubocop/cop/chef/**/*.rb") do |file|
  next if File.directory?(file)

  require_relative file # not actually relative but require_relative is faster
end

RuboCop::ConfigLoader.default_configuration = RuboCop::ConfigLoader.configuration_from_file(Chefstyle.config)
