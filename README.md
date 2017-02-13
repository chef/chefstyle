# Chefstyle - Version Pinned rubocop and sane defaults for Ruby

[![Gem Version](https://badge.fury.io/rb/chefstyle.svg)](https://badge.fury.io/rb/chefstyle) [![Build Status](https://travis-ci.org/chef/chefstyle.svg?branch=master)](https://travis-ci.org/chef/chefstyle)

This is an internal style guide for chef ruby projects (chef-client,
ohai, mixlib-shellout, mixlib-config, etc).

It is not meant for consumption by cookbooks or for any general
purpose uses.  **Chef Users and Customers Should Generally Not Use
This Tool and Should Use Cookstyle**.  It is not intended for any audience
outside of chef core ruby development.

It will conflict with rubocop defaults, cookstyle, finstyle and other
ruby style guides entirely by design.  The point is that the core
chef authors vehemently disagree with them on points of style and this
point is generally not up for debate.

It will have many rules that are disabled simply because fixing a
project as large as chef-client would be tedious and have little
value.  It will have other rules that are disabled because chef
exposes edge conditions that make them falsely alert.  Other rules
will be selected based on the biases of the core chef developers
which are often violently at odds with the rubocop core developers
over ruby style.

Pull requests to this repo will not be accepted without corresponding
PRs into at least the chef-client and ohai codebases to clean the
code up.  PRs will not be accepted that assume unfunded mandates for
other people to finish the work.  Do not open PRs offering opinions
or suggestions without offering to do the work.

The project itself is a derivative of
[finstyle](https://github.com/fnichol/finstyle), but starts with all
rules disabled.  The active ruleset is in the
[config/chefstyle.yml](https://github.com/chef/chefstyle/blob/master/config/chefstyle.yml)
file.

## How It Works

This library has a direct dependency on one specific version of RuboCop (at a time), and [patches it][patch] to load the [upstream configuration][upstream] and [custom set][config] of rule updates. When a new RuboCop release comes out, this library can rev its pinned version dependency and [re-vendor][rakefile] the upstream configuration to determine if any breaking style or lint rules were added/dropped/reversed/etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chefstyle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chefstyle

## Usage

### Vanilla RuboCop

Run RuboCop as normal, simply add a `-r chefstyle` option when running:

```sh
rubocop -r chefstyle -D --format offenses
```

### chefstyle Command

Use this tool just as you would RuboCop, but invoke the `chefstyle` binary
instead which patches RuboCop to load rules from the chefstyle gem. For example:

```sh
chefstyle -D --format offenses
```

### Rake

In a Rakefile, the setup is exactly the same, except you need to require the
chefstyle library first:

```ruby
require "chefstyle"
require "rubocop/rake_task"
RuboCop::RakeTask.new do |task|
  task.options << "--display-cop-names"
end
```

### guard-rubocop

You can use one of two methods. The simplest is to add the `-r chefstyle` option to the `:cli` option in your Guardfile:

```ruby
guard :rubocop, cli: "-r chefstyle" do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
```

Alternatively you could pass the path to Chefstyle's configuration by using the `Chefstyle.config` method:

```ruby
require "chefstyle"

guard :rubocop, cli: "--config #{Chefstyle.config}" do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
```

### git pre-commit hoooks

In any repo a pre-commit hook can be used in .git/hooks/pre-commit to catch offenses before checkin:

```ruby
#!/usr/bin/env ruby

changed_files = `git diff --name-only --cached`.split.select { |f| File.extname(f) == ".rb" }

unless changed_files.empty?
  system "chefstyle #{changed_files.join(" ")}"
  unless $?.success?
    puts "\n\nthere was a chefstyle error, please fix before commiting:"
    puts "(chefstyle -a may be able to autofix these issues for you)\n\n"
  end
end
exit $?.to_s[-1].to_i
```

For whatever `$REASON` git does not allow easily distributing hooks in the repo itself so each individual user
needs to set this up.

### .rubocop.yml

As with vanilla RuboCop, any custom settings can still be placed in a `.rubocop.yml` file in the root of your project.
