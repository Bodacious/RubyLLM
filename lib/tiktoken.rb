# frozen_string_literal: true
class Tiktoken
  require 'forwardable'
  require "pycall/import"
  extend Forwardable
  include PyCall::Import

  ENCODING_MODEL_CL100K_BASE = 'cl100k_base'

  def initialize(encoding = ENCODING_MODEL_CL100K_BASE)
    pyimport :tiktoken
    @tokenizer = tiktoken.get_encoding(encoding)
  rescue LoadError, PyCall::PyError => e
    warn "tiktoken not installed in the Python environment used by PyCall"
    raise e
  end

  def encode(text)
    Array(@tokenizer.encode(text))
  end

  def decode(tokens)
    @tokenizer.decode(tokens)
  end
end
