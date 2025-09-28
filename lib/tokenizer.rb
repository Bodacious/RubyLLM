# frozen_string_literal: true

class Tokenizer
  BOS = '!!!'
  EOS = '``'

  def bos
    self.class::BOS
  end

  def eos
    self.class::EOS
  end

  def bos_tokens
    tokenize(bos)
  end

  def eos_tokens
    tokenize(eos)
  end

  def tokenize(text)
    raise NotImplementedError
  end

  def detokenize(tokens)
    raise NotImplementedError
  end
end
