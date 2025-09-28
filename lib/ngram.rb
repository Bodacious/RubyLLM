# frozen_string_literal: true

NGram = Data.define(:tokens) do
  def context
    tokens[0...-1]
  end

  def start_with?(prefix)
    context.first(prefix.size) == prefix
  end

  def last_token
    tokens.last
  end
end
