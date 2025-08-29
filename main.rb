require_relative 'sampler'

class TrigramLM
  BOS1 = "<BOS1>"
  BOS2 = "<BOS2>"
  EOS  = "<EOS>"
  UNK  = "<UNK>"

  attr_reader :vocab

  def initialize(alpha: 0.4, min_count: 1, seed: 1234)
    @alpha = alpha
    @min_count = min_count
    @rng = Random.new(seed)

    @uni = Hash.new(0)
    @bi = Hash.new { |h, a| h[a] = Hash.new(0) }       # a -> { b => count }
    @tri = Hash.new { |h, ab| h[ab] = Hash.new(0) }    # [a,b] -> { c => count }
    @vocab = nil
    @total_unigrams = 0
  end

  def tokenize(s)
    s.downcase.scan(/\b[\p{Alnum}’']+\b/)
  end

  def fit(corpus)
    # 1) Raw unigram counts
    raw_uni = Hash.new(0)
    corpus.each do |line|
      tokens = tokenize(line)
      ([BOS1, BOS2] + tokens + [EOS]).each { |t| raw_uni[t] += 1 }
    end

    # 2) Build vocab with UNK
    base_vocab = raw_uni.select { |_t, c| c >= @min_count }.keys
    @vocab = (base_vocab | [UNK, BOS1, BOS2, EOS]).uniq

    # 3) Recount n-grams with OOV -> UNK
    corpus.each do |line|
      toks = map_to_vocab(tokenize(line))
      seq = [BOS1, BOS2] + toks + [EOS]

      seq.each { |t| @uni[t] += 1; @total_unigrams += 1 }
      seq.each_cons(2) { |a, b| @bi[a][b] += 1 }
      seq.each_cons(3) { |a, b, c| @tri[[a, b]][c] += 1 }
    end

    self
  end

  def next_probs(prev2, prev1, temperature: 1.0)
    scores = backoff_scores(prev2, prev1) # unnormalised
    probs = normalise(scores)
    return probs if (temperature - 1.0).abs < 1e-12
    return argmax_onehot(probs) if temperature <= 1e-6
    tempered = probs.transform_values { |p| p**(1.0 / temperature) }
    normalise(tempered)
  end

  def predict_next(prev2, prev1, k: 5, temperature: 1.0)
    next_probs(prev2, prev1, temperature:).sort_by { |_t, p| -p }.first(k)
  end

  def generate(max_tokens: 50, temperature: 1.0)
    out = []
    a, b = BOS1, BOS2
    max_tokens.times do
      probs = next_probs(a, b, temperature:)
      t = sample(probs)
      break if t == EOS
      out << t
      a, b = b, t
    end
    out.join(" ")
  end

  def perplexity(corpus)
    n = 0
    logp = 0.0
    corpus.each do |line|
      toks = [BOS1, BOS2] + map_to_vocab(tokenize(line)) + [EOS]
      toks.each_cons(3) do |a, b, c|
        p = next_probs(a, b)[c]
        p = 1e-12 if p <= 0.0
        logp += Math.log(p)
        n += 1
      end
    end
    Math.exp(-logp / n)
  end

  private

  def map_to_vocab(tokens)
    tokens.map { |t| @vocab.include?(t) ? t : UNK }
  end

  def total_bi(a)
    @bi[a].values.sum
  end

  def total_tri(ab)
    @tri[ab].values.sum
  end

  # Stupid backoff scores (not normalised):
  # if c(a,b,c)>0: p = c(a,b,c)/c(a,b)
  # elsif c(b,c)>0: p = α * c(b,c)/c(b)
  # else: p = α^2 * c(c)/N
  def backoff_scores(a, b)
    scores = {}
    @vocab.each do |c|
      next if c == BOS1 || c == BOS2 # never predict BOS
      if @tri[[a, b]][c] > 0
        denom = total_tri([a, b])
        scores[c] = safe_div(@tri[[a, b]][c], denom)
      elsif @bi[b][c] > 0
        denom = total_bi(b)
        scores[c] = @alpha * safe_div(@bi[b][c], denom)
      else
        scores[c] = (@alpha**2) * safe_div(@uni[c], @total_unigrams)
      end
    end
    scores
  end

  def normalise(hash)
    s = hash.values.sum
    return hash.transform_values { 0.0 } if s <= 0.0
    hash.transform_values { |v| v / s }
  end

  def argmax_onehot(probs)
    t, _p = probs.max_by { |_tk, p| p }
    probs.keys.map { |k| [k, (k == t ? 1.0 : 0.0)] }.to_h
  end

  def sample(dist_hash)
    r = @rng.rand
    acc = 0.0
    dist_hash.each do |t, p|
      acc += p
      return t if r <= acc
    end
    dist_hash.keys.last
  end

  def safe_div(a, b)
    return 0.0 if b <= 0
    a.fdiv(b)
  end
end

lm = TrigramLM.new.fit([
                         "cleo card is great",
                         "cleo card helps budget",
                         "cleo card is useful",
                         "cleo card is useful",
                         "cleo card is silly",
                         "cleo card is the best",
                       ])

sampler = Sampler.new(seed: 42)
puts sampler.generate(lm, max_tokens: 12, strategy: :greedy)
puts sampler.generate(lm, max_tokens: 12, strategy: :temperature, temperature: 0.7)
puts sampler.generate(lm, max_tokens: 12, strategy: :top_k, k: 5)
puts sampler.generate(lm, max_tokens: 12, strategy: :top_p, p: 0.9)
