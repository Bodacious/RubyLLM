NGramProbability = Data.define(:ngram, :probability) do
  def initialize(...)
    super
    validate_fields!
  end

  def validate_fields!

    validate_probability_between_zero_and_one!
  end

  def validate_probability_between_zero_and_one!
    return if Range.new(0.0, 1.0).cover?(probability)

    raise ArgumentError, "probability was not between zero and one (#{probability})"
  end
end
