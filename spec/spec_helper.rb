# frozen_string_literal: true
require "rubocop"
require "rubocop/rspec/support"

module SpecHelper
  ROOT = Pathname.new(__dir__).parent.freeze
end

spec_helper_glob = File.expand_path("{support,shared}/*.rb", __dir__)
Dir.glob(spec_helper_glob).map(&method(:require))

RSpec.configure do |config|
  # Basic configuration
  config.run_all_when_everything_filtered = true
  config.filter_run(:focus)
  config.order = :random

  config.include RuboCop::RSpec::ExpectOffense
end

require "chefstyle"
