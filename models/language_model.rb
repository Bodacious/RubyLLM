# frozen_string_literal: true

class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    sequence = ["the"]
    Array.new(sequence_length) do |i|
      sequence << generate_next_token(context: sequence.last)
    end
    sequence.join(' ')
  end

  protected

  TokenProbability = Data.define(:token, :probability)

  def generate_next_token(context:)
    @probability_distributions[context].max_by(&:probability).token
  end

  def calculate_probability_distributions
    token_counts = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = 0 } }
    DOCUMENT.split.each_cons(2) do |(t1, t2)|
      token_counts[t1][t2] += 1
    end

    token_counts.map do |context, target_counts|
      total_token_count = target_counts.values.sum
      target_probabilities = target_counts.map { |target, count|
        probability =  count / total_token_count.to_f
        TokenProbability[target, probability]
      }

      [context, target_probabilities]
    end.to_h
  end
end
