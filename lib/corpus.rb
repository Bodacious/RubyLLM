class Corpus
  require_relative 'tokenizer'

  SENTENCE_REGEXP = /(?m)[\s\S]*?[.!?](?=\s|$)/


  IGNORED_PUNCTUATION_REGEXP = /'|"|“|”|\r?\n/

  def initialize(name: :simple)
    @name = name.to_sym
    @samples = read_corpus_file
  end

  def samples = @samples.dup

  def read_corpus_file
    File.read("./corpora/#{@name}_text.txt")
        .each_line
        .map do |string|
      string.gsub!(IGNORED_PUNCTUATION_REGEXP, '')
      string
    end
        .select { |sentence| sentence.strip.length > 1 }
      .map { |sentence| "#{Tokenizer::BOS} #{sentence.downcase} #{Tokenizer::EOS}" }
  end
end
