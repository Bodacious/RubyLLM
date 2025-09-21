class Corpus
  BOS = "[BOS]"
  EOS = "[EOS]"
  def initialize(name: :simple)
    @name = name
    @samples = read_corpus_file(name)
  end

  def samples = @samples.dup

  def read_corpus_file(corpus_name)
    File.read("./corpora/#{corpus_name}_text.txt")
        .split(/[^.!?]+[.!?]+(?:\s+|$)/)
        .map { |sentence| "#{BOS} #{sentence.strip} #{EOS}" }
  end
end
