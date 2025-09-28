class BPETokenizer < Tokenizer
  require "pycall/import"
  include PyCall::Import

  def initialize(encoding: "cl100k_base")
    pyimport :tiktoken
    @encoder = tiktoken.get_encoding(encoding)
    super()
  end

  def tokenize(text)
    Array(@encoder.encode(text))
  end

  def detokenize(tokens)
    @encoder.decode(tokens)
  end
end
