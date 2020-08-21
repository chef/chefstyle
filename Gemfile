# frozen_string_literal: true
source "https://rubygems.org"

# Specify your gem's dependencies in chefstyle.gemspec
gemspec

group :debug do
  gem "pry"
  gem "pry-byebug"
  gem "pry-stack_explorer", "~> 0.4.0" # 0.5.0 drops support for Ruby < 2.6
end

group :development do
  gem "rake", ">= 12.0"
  gem "rspec", ">= 3.4"
end