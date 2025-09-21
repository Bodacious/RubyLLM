class Corpus
  BOS = "[BOS]"
  EOS = "[EOS]"
  SENTENCE_REGEXP = /[^.!?]+(?:\s+|\.|!|\?|$)/

  IGNORED_PUNCTUATION_REGEXP = /'|"|”/

  def initialize(name: :simple)
    @name = name.to_sym
    @samples = read_corpus_file
  end

  def samples = @samples.dup

  def read_corpus_file
    File.read("./corpora/#{@name}_text.txt")
        .scan(SENTENCE_REGEXP)
        .map do |string|
      string.downcase!
      string.strip!
      string.gsub!(IGNORED_PUNCTUATION_REGEXP, '')
      string
    end
        .select { |sentence| sentence.length > 1 }
        .map { |sentence| "#{BOS} #{sentence} #{EOS}" }
  end
end
