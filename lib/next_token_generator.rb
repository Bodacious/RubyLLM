# frozen_string_literal: true

class NextTokenGenerator
  def initialize(probability_distribution:)
    @probability_distribution = probability_distribution
  end

  def generate_next(context:)
    distribution = @probability_distribution.distribution_for(context)
    return nil if distribution.tokens.empty?

    distribution.next_token
  end
end
