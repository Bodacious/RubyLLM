# frozen_string_literal: true

class ConditionalDistribution
  def initialize(context:, token_probs:, temperature: ENV.fetch('TEMPERATURE', 1.0))
    @context = context
    @token_probs = token_probs # { NGram => Float (probability) }
    @temperature = temperature.to_f
    raise ArgumentError, "temperature must be > 0" unless @temperature.positive?

    apply_temperature_scaling!
  end

  attr_reader :context

  def next_token
    r = rand
    cumulative = 0.0
    @token_probs.each do |ngram, prob|
      cumulative += prob
      return ngram.last_token if r <= cumulative
    end
    @token_probs.keys.last
  end

  def tokens
    @token_probs.keys
  end

  private

  def apply_temperature_scaling!
    # Power transform: p^(1/T), then renormalise
    scaled = @token_probs.transform_values { |p| p**(1.0 / @temperature) }

    total = scaled.values.sum
    @token_probs = scaled.transform_values { |v| v / total }
  end
end
