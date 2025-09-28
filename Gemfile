# frozen_string_literal: true

source "https://rubygems.org"

ruby file: "./.ruby-version"

# pycall (https://github.com/mrkn/pycall)
gem "pycall", "~> 1.5", require: false
# A libffi wrapper for Ruby. (https://github.com/ruby/fiddle)
gem "fiddle", "~> 1.1", require: false

group :development, :test do
  # Debugging functionality for Ruby (https://github.com/ruby/debug)
  gem "debug"
  # Provides a simple logging utility for outputting messages. (https://github.com/ruby/logger)
  gem "logger"
  # Guard keeps an eye on your file modifications (https://guard.github.io/guard/)
  gem "guard"
  # Guard plugin for the Minitest framework (https://rubygems.org/gems/guard-minitest)
  gem "guard-minitest"
  # Automatic Ruby code style checking tool. (https://github.com/rubocop/rubocop)
  gem 'rubocop', require: false
  # Rake is a Make-like program implemented in Ruby (https://github.com/ruby/rake)
  gem "rake", "~> 13.3"
  # Add comments to your Gemfile with each dependency's description. (https://github.com/ivantsepp/annotate_gem)
  gem "annotate_gem", "~> 0.0.14"
end

group  :test do
  # Mocking and stubbing library (https://mocha.jamesmead.org)
  gem "mocha"
  # minitest provides a complete suite of testing facilities supporting TDD, BDD, mocking, and benchmarking (https://github.com/minitest/minitest)
  gem "minitest", "~> 5.25"
end
