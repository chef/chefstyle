require "chefstyle/version"

# ensure the desired target version of RuboCop is gem activated
gem "rubocop", "= #{Chefstyle::RUBOCOP_VERSION}"
require "rubocop"

# Chefstyle patches the RuboCop tool to set a new default configuration that
# is vendored in the Chefstyle codebase.
module Chefstyle
  DEFAULT_FILE = File.join(File.dirname(__FILE__), "..", "config", "chefstyle.yml")

  def self.init
    RuboCop::ConfigStore.new.tap do |config_store|
      config_store.options_config = DEFAULT_FILE
    end
  end
end
