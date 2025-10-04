TokenProbability = Data.define(:token, :probability)
class Tokenizer
  def initialize(document:)
    @tokens = document.to_s.split
  end
  def tokens
    @tokens
  end
end

class ProbabilityDistribution
  def initialize(token_counts = {})
    @token_counts = token_counts
  end

  def [](context)
    distribution.fetch(context, [])
  end
  def distribution
    return @distribution if defined?(@distribution)

    @distribution = @token_counts.map do |context, target_counts|
      total_token_count = target_counts.values.sum
      target_probabilities = target_counts.map { |target, count|
        probability = count / total_token_count.to_f
        TokenProbability[target, probability]
      }

      [context, target_probabilities]
    end.to_h
  end
end
class NGramCounter
  def initialize(tokens, n: 2)
    @tokens = tokens
    @n = n
    # Each key in this hash defaults to a value of a new hash with default 0
    #   Example:
    #     counts['foo']['bar'] # => 0
    #     counts # => { "foo" => { "bar" => 0 }}
    @counter = Hash.new { |h, k| h[k] = Hash.new(0) }
    count_n_grams
  end

  def token_counts
    @counter
  end

  protected
  def count_n_grams
    @tokens.each_cons(@n) do |(t1, t2)|
      @counter[t1][t2] += 1
    end
    @counter
  end
end

class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    sequence = ["the"]
    Array.new(sequence_length) do
      sequence << generate_next_token(context: sequence.last)
    end
    sequence.join(' ')
  end

  protected

  def generate_next_token(context:)
    @probability_distributions[context].max_by(&:probability).token
  end

  def calculate_probability_distributions
    tokens = Tokenizer.new(document: DOCUMENT).tokens
    token_counts = NGramCounter.new(tokens).token_counts
    ProbabilityDistribution.new(token_counts)
  end
end
