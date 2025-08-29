# test_sampling_strategies_minitest.rb
require "minitest/autorun"
require_relative "sampler"

class SamplerTest < Minitest::Test
  def test_greedy_returns_argmax
    s = Sampler.new(seed: 1)
    probs = { "a" => 0.4, "b" => 0.35, "c" => 0.25 }
    tok = s.pick(probs, strategy: :greedy)
    assert_equal "a", tok
  end

  def test_temperature_low_converges_to_argmax
    s = Sampler.new(seed: 1)
    probs = { "x" => 0.51, "y" => 0.49 }
    tok = s.pick(probs, strategy: :temperature, temperature: 1e-9)
    assert_equal "x", tok
  end

  def test_top_k_limits_candidates
    s = Sampler.new(seed: 123)
    probs = { "a" => 0.6, "b" => 0.25, "c" => 0.15 }
    20.times do
      tok = s.pick(probs, strategy: :top_k, k: 1)
      assert_equal "a", tok
    end
  end

  def test_top_p_keeps_minimum_mass
    s = Sampler.new(seed: 7)
    probs = { "a" => 0.6, "b" => 0.25, "c" => 0.1, "d" => 0.05 }
    20.times do
      tok = s.pick(probs, strategy: :top_p, p: 0.8) # should keep a+b only
      assert_includes %w[a b], tok
    end
  end

  def test_random_sampling_respects_relative_likelihoods
    s = Sampler.new(seed: 9)
    probs = { "H" => 0.7, "T" => 0.3 }
    counts = Hash.new(0)
    1000.times { counts[s.pick(probs, strategy: :temperature, temperature: 1.0)] += 1 }
    assert_operator counts["H"], :>, counts["T"]
  end
end
