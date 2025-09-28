# frozen_string_literal: true

guard :minitest do
  # When a test file itself changes, rerun it
  watch(%r{^test/(.+)_test\.rb$})

  # When a model file changes, rerun its corresponding test
  watch(%r{^models/(.+)\.rb$}) { |m| "test/models/#{m[1]}_test.rb" }

  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  # If test_helper changes, rerun the whole suite
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end
