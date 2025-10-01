# Ruby and Language Models 

---

```ruby
# frozen_string_literal: true

class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  MAX_TOKENS = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length: MAX_TOKENS)
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

Example with distribution {A: 0.7, B: 0.2, C: 0.1}:
T = 0.5 (sharpen) → A: 0.91, B: 0.07, C: 0.02
T = 1 (no change) → A: 0.70, B: 0.20, C: 0.10
T = 2 (flatten) → A: 0.52, B: 0.28, C: 0.20

---

> "Information is not knowledge.
> Knowledge is not wisdom.
> Wisdom is not truth."
> —Frank Zappa
