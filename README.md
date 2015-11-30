# Chefstyle - Version Pinned rubocop and sane defaults for Ruby

This is a set of rubocop rules that implements a style guide for Chef
Software's ruby projects. It should not be used as best practice for
cookbook formatting.

The project itself is a derivative of
[finstyle](https://github.com/fnichol/finstyle), but starts with all
rules disabled.

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

### .rubocop.yml

As with vanilla RuboCop, any custom settings can still be placed in a `.rubocop.yml` file in the root of your project.
