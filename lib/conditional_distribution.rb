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
    logits = @token_probs.values.map { |probability| Math.log(probability) }
    scaled = logits.map { |logit| Math.exp(Rational(logit, @temperature)) }

    total = scaled.sum
    normalised = scaled.map { |val| Rational(val, total) }

    @token_probs.zip(normalised).map do |(ngram, _p), new_probability|
      @token_probs[ngram] = new_probability
    end
  end
end
