# Learning language models with Ruby 

---

# What we'll cover

---

# Super simple unigram example 

```ruby
DOCUMENT = 'the cat sat on the mat'
DEFAULT_SEQUENCE_LENGTH = 10

tokens = DOCUMENT.split
token_counts = tokens.tally
total_token_count = token_counts.values.sum
probability_distributions = token_counts.transform_values do |count| 
  count / total_token_count.to_f
end

def generate_next_token(probability_distributions)
  probability_distributions.max_by(&:last).first
end

sequence = Array.new(DEFAULT_SEQUENCE_LENGTH) do
  generate_next_token(probability_distributions)
end

puts sequence.join(' ')
```

---

# Cleaned up unigram example 

```ruby
class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    Array.new(sequence_length) { generate_next_token }.join(' ')
  end

  protected

  def generate_next_token
    @probability_distributions.max_by(&:last).first
  end

  def calculate_probability_distributions
    token_counts = DOCUMENT.split.tally
    total_token_count = token_counts.values.sum
    token_counts.transform_values { |count| count / total_token_count.to_f }
  end
end
```
---

# OOP Unigram model

---

```ruby
class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize(document: DOCUMENT)
    @document = document
    @probability_distribution = calculate_probability_distribution
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    Array.new(sequence_length) { generate_next_token }.join(' ')
  end

  protected

  def generate_next_token
    @probability_distribution.max_by(&:probability).token
  end

  def calculate_probability_distribution
    tokens = Tokenizer.new(document: @document).tokens
    token_counts = NGramCounter.new(tokens).token_counts
    ProbabilityDistribution.new(token_counts).distribution
  end
end
```

---

```
the the the the the the the the the the
```

---
 
What is an NGram?

```
the cat sat on the mat
```

---

What is an NGram?

```
the cat sat on the mat
```

1. `the cat`
2. `cat sat`
3. `sat on`
4. `on the`
5. `the mat`


--- 

# Temperature

```
Example with distribution 
{A: 0.7, B: 0.2, C: 0.1}:

T = 0.5 (sharpen)   → A: 0.91, B: 0.07, C: 0.02
T = 1   (no change) → A: 0.70, B: 0.20, C: 0.10
T = 2   (flatten)   → A: 0.52, B: 0.28, C: 0.20
```

---

#

---

> "Information is not knowledge.
> Knowledge is not wisdom.
> Wisdom is not truth."
> —Frank Zappa
