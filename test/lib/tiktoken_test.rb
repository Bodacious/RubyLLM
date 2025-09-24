require "test_helper"
require "tiktoken"

class TiktokenTest < Minitest::Test
  def test_initialize_loads_the_tokenizer_without_error
    tokenizer = Tiktoken.new
    assert_kind_of Tiktoken, tokenizer
  end

  def test_encode_converts_text_into_an_array_of_integers
    tokenizer = Tiktoken.new
    tokens = tokenizer.encode("the cat sat")
    
    assert_kind_of Array, tokens
    assert tokens.all? { |t| t.is_a?(Integer) }
    assert_operator tokens.length, :>, 0
  end

  def test_decode_converts_tokens_back_into_a_string
    tokenizer = Tiktoken.new
    text = "the cat sat"
    tokens = tokenizer.encode(text)
    decoded = tokenizer.decode(tokens)

    assert_kind_of String, decoded
    assert_includes decoded, "the"
  end

  def test_encode_and_decode_are_roughly_inverse
    tokenizer = Tiktoken.new
    original = "hello world"
    tokens = tokenizer.encode(original)
    roundtrip = tokenizer.decode(tokens)

    assert_match(/hello/, roundtrip)
    assert_match(/world/, roundtrip)
  end
end
