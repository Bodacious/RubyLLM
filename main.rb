require 'bundler'
Bundler.require(:default)

require_relative "corpus"
corpus = Corpus.new(
  "To be or not to be, that is the question"
)

tokens = corpus.tokens

freq = tokens.tally

total = tokens.size.to_f
probs = freq.transform_values { |count| count / total }

def sample(probs)
  probs.sort_by { |token, probability| -probability }.first
end

token, probability = sample(probs)
puts "Token: #{token}, probability: #{probability}"
