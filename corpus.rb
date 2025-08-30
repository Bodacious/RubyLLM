require 'delegate'

class Corpus < DelegateClass(Array)
  def initialize(*lines)
    super(lines)
  end

  def tokens
    join(" ").split
  end
end
