NGram = Data.define(:tokens) do
  def start_with?(lookback_context)
    tokens.first(lookback_context.size) == lookback_context
  end

  def last_token
    tokens.last
  end
end
