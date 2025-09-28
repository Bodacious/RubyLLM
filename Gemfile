# frozen_string_literal: true

source "https://rubygems.org"

ruby file: "./.ruby-version"

gem "pycall", "~> 1.5"
gem "fiddle", "~> 1.1"

group :development, :test do
  gem "debug"
  gem "logger"
  gem "guard"
  gem "guard-minitest"
  gem 'rubocop', require: false
end

group  :test do
  gem "mocha"
  gem "minitest", "~> 5.25"
end

gem "rake", "~> 13.3"
