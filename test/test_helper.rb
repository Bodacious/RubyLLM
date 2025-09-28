# frozen_string_literal: true

require 'bundler'

Bundler.setup(:default, :development, :test)

require 'minitest/autorun'

require 'mocha/minitest'

$LOAD_PATH << File.expand_path('../lib', __dir__)
