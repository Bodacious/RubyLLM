# frozen_string_literal: true

require 'bundler'

Bundler.setup(:development)

class BigramNoSampling
  CORPUS = "the cat sat on the mat".split
  MAX_TOKENS = 10

  Bigram = Data.define(:tokens) do
    def start_with?(token)
      tokens.first == token
    end

    def last_word
      tokens.last
    end
  end
  BigramProbability = Data.define(:bigram, :probability)

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(prompt: nil, sequence_length: MAX_TOKENS)
    output = [prompt.downcase]

    until output.last.nil?
      break if output.length >= sequence_length
      context = output.last
      next_token = generate_next_token(context)
      output << next_token
    end

    output.compact.join(" ")
  end

  protected

  def generate_next_token(context)
    highest_probability_bigram = @probability_distributions
                                   .filter { |bigram_prob| bigram_prob.bigram.start_with?(context) }
                                   .sort_by
                                   .with_index{ |bigram_prob, i| [-bigram_prob.probability, -i] }
                                   .reverse
                                   .first
    return nil if highest_probability_bigram.nil?
    highest_probability_bigram.bigram.last_word
  end

  def calculate_probability_distributions
    bigrams = CORPUS.each_cons(2).collect { |tokens| Bigram[tokens] }
    bigram_counts = bigrams.tally
    total_bigrams_count = bigram_counts.values.sum
    bigram_counts.map do |bigram, count|
      probability = Rational(count, total_bigrams_count)
      BigramProbability[bigram, probability.to_f]
    end
  end
end
