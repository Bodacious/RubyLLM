# frozen_string_literal: true

require_relative 'tokenizer'
class WordTokenizer < Tokenizer
  def tokenize(text)
    text.scan(/[[:word:]']+|`{2}/)
  end

  def detokenize(tokens)
    tokens.join(' ')
  end
end
