# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Run the full test suite'
task default: :test
