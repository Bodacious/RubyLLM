# frozen_string_literal: true

NGramProbability = Data.define(:context, :token, :probability) do
  def to_s
    "#{context.inspect} -> #{token}: #{probability.round(4)}"
  end
end
