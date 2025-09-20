# frozen_string_literal: true

source "https://rubygems.org"

ruby file: "./.ruby-version"

gem "torch-rb", "~> 0.21.0"

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
