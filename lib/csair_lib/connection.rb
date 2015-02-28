class Connection

  def initialize
    @connection_hash = SortedSet.new
  end

  # @param [String] first
  # @param [String] second
  def add_connection(first, second)
    unless first == second
      @connection_hash.add(alphabetical_order(first, second))
    end
  end

  # @return [String]
  def get_connection_url
    url_string = String.new
    @connection_hash.each do |connection|
      url_string << connection + ',+'
    end
    url_string[0..-3]
  end

  private

  # @param [String] two
  # @param [String] words
  # @return [String]
  def dash_between_uppercase(two, words)
    two.upcase + '-' + words.upcase
  end

  # @param [String] first
  # @param [String] second
  # @return [String]
  def alphabetical_order(first, second)
    first.downcase < second.downcase ? dash_between_uppercase(first, second) : dash_between_uppercase(second, first)
  end

end