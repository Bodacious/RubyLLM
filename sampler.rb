# sampling_strategies.rb
class Sampler
  def initialize(seed: 1234)
    @rng = Random.new(seed)
  end

  # probs: {"a"=>0.6, "b"=>0.3, "c"=>0.1}
  # strategy: :greedy | :temperature | :top_k | :top_p
  def pick(probs, strategy: :greedy, temperature: 1.0, k: nil, p: nil)
    case strategy
    when :greedy
      argmax(probs)
    when :temperature
      sample(scale_temperature(probs, temperature))
    when :top_k
      raise ArgumentError, "k must be >= 1" unless k && k >= 1
      sample(cut_top_k(probs, k))
    when :top_p
      raise ArgumentError, "p must be in (0,1]" unless p && p > 0 && p <= 1
      sample(cut_top_p(probs, p))
    else
      raise ArgumentError, "unknown strategy: #{strategy}"
    end
  end

  def generate(lm, max_tokens:, strategy: :greedy, temperature: 1.0, k: nil, p: nil)
    a, b = lm.class::BOS1, lm.class::BOS2
    out = []
    max_tokens.times do
      probs = lm.next_probs(a, b, temperature: 1.0) # keep base dist; apply sampling below
      t = pick(probs, strategy:, temperature:, k:, p:)
      break if t == lm.class::EOS
      out << t
      a, b = b, t
    end
    out.join(" ")
  end

  private

  def argmax(probs)
    probs.max_by { |_, pr| pr }.first
  end

  def normalize(hash)
    s = hash.values.sum
    return hash.transform_values { 0.0 } if s <= 0.0
    hash.transform_values { |v| v / s }
  end

  def scale_temperature(probs, temp)
    return argmax_onehot(probs) if temp <= 1e-9
    return normalize(probs) if (temp - 1.0).abs < 1e-12
    scaled = probs.transform_values { |p| p**(1.0 / temp) }
    normalize(scaled)
  end

  def argmax_onehot(probs)
    top = argmax(probs)
    probs.keys.map { |k| [k, (k == top ? 1.0 : 0.0)] }.to_h
  end

  def cut_top_k(probs, k)
    kept = probs.sort_by { |_, p| -p }.first(k).to_h
    normalize(kept)
  end

  def cut_top_p(probs, p)
    sorted = probs.sort_by { |_, pr| -pr }
    acc = 0.0
    kept = []
    sorted.each do |pair|
      kept << pair
      acc += pair.last
      break if acc >= p
    end
    normalize(kept.to_h)
  end

  def sample(dist)
    r = @rng.rand
    acc = 0.0
    dist.each do |tok, pr|
      acc += pr
      return tok if r <= acc
    end
    dist.keys.last
  end
end
