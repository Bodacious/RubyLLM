class Tokenizer
  require "pycall/import"
  include PyCall::Import
  require "forwardable"
  extend Forwardable

  BOS = '!!!'
  EOS = '``'

  def initialize(encoding: "cl100k_base")
    pyimport :tiktoken
    @encoder = tiktoken.get_encoding(encoding)
  end

  def self.eos_tokens(...)
    new(...).tokenize(EOS)
  end

  def tokenize(text)
    Array(@encoder.encode(text))
  end

  def detokenize(tokens)
    @encoder.decode(tokens)
  end
end
