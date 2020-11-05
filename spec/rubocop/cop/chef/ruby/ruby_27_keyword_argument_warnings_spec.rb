# frozen_string_literal: true
#
# Copyright:: Chef Software, Inc.
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "spec_helper"

describe RuboCop::Cop::Chef::Ruby::Ruby27KeywordArgumentWarnings, :config do
  subject(:cop) { described_class.new(config) }

  it "registers an offense when passing a hash with brackets to shell_out" do
    expect_offense(<<~RUBY)
    shell_out('hostnamectl status', {returns: [0, 1]})
                                    ^^^^^^^^^^^^^^^^^ Pass options to shell_out helpers without the brackets to avoid Ruby 2.7 deprecation warnings.
    RUBY

    expect_correction(<<~RUBY)
    shell_out('hostnamectl status', returns: [0, 1])
    RUBY
  end

  it "registers an offense when passing a hash with brackets to shell_out!" do
    expect_offense(<<~RUBY)
    shell_out!('hostnamectl status', {returns: [0, 1]})
                                     ^^^^^^^^^^^^^^^^^ Pass options to shell_out helpers without the brackets to avoid Ruby 2.7 deprecation warnings.
    RUBY

    expect_correction(<<~RUBY)
    shell_out!('hostnamectl status', returns: [0, 1])
    RUBY
  end

  it "doesn't register an offense when properly passing options to the helpers" do
    expect_no_offenses("shell_out!('hostnamectl status', returns: [0, 1])")
  end
end
