DOCUMENT = 'the cat sat on the mat'
DEFAULT_SEQUENCE_LENGTH = 10

tokens = DOCUMENT.split
token_counts = tokens.tally
# => { 'the' => 2, 'cat' => 1, => 'sat' => 1, 'on' => 1, 'mat' => 1}
total_token_count = token_counts.values.sum
probability_distribution = token_counts.transform_values do |count|
  count / total_token_count.to_f
end
# => { "the" => 0.3333333333333333,  "cat" => 0.16666666666666666, ... }

def generate_next_token(probability_distribution)
  probability_distribution.max_by(&:last).first
end

sequence = Array.new(DEFAULT_SEQUENCE_LENGTH) do
  generate_next_token(probability_distribution)
end

puts sequence.join(' ')
