require 'bundler'

Bundler.setup(:development, :test)

require 'minitest/autorun'

$LOAD_PATH << File.expand_path('../lib', __dir__)
