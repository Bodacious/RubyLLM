require 'bundler'
Bundler.require(:default)

corpus = "To be or not to be, that is the question"
tokens = corpus.split

freq = tokens.tally

total = tokens.size.to_f
probs = freq.transform_values { |count| count / total }

def sample(probs)
  probs.sort_by { |token, probability| -probability }.first
end

token, probability = sample(probs)
puts "Token: #{token}, probability: #{probability}"
