require_relative 'reader'
require_relative 'connection'

# Class created to handle graph creation and reading for the CSAir flight network.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
class Graph

  attr_reader :node_hash

  # Reference value for infinity.
  INFTY = 1.0/0.0

  # Initializes a Graph object.
  def initialize
    @node_hash = Hash.new
    @connectors = Connection.new
    create_graph_from_json
  end

  # Gets a string with appropriate formatting for a graph.
  #
  # @return [String] A string whose lines contain one of the nodes (airport codes) and its connections.
  #
  def to_s
    graph_string = '{Graph}'
    @node_hash.each do |node, node_hash|
      graph_string << get_node_connections(node, node_hash)
    end
    graph_string
  end

  # Adds a connection between two nodes in the graph, creating them if necessary.
  #
  # @param [String] first_port The first airport code
  # @param [String] second_port The second airport code
  # @param [Integer] distance The distance between the airports (by flight) in miles.
  #
  def add_connection(first_port, second_port, distance)
    add_if_non_existing(first_port)
    add_if_non_existing(second_port)
    @connectors.add_connection(first_port, second_port)
    @node_hash[first_port][second_port] = distance
    @node_hash[second_port][first_port] = distance
  end

  # Gets the value of a connection (or route) between two nodes (or airports).
  #
  # ## Edge cases
  #
  # * The airports are equal: returns 0;
  # * One of the airports does not exist: returns -1 (does not break Dijkstra's algorithm);
  # * The airports do not have routes between them: returns infinity;
  #
  # @param [String] first_port The first airport code.
  # @param [String] second_port The second airport code.
  #
  # @return [Integer] The distance
  #
  def get_connection(first_port, second_port)
    case
      when one_does_not_exist(first_port, second_port) then
        -1
      when first_port == second_port then
        0
      else
        @node_hash[first_port][second_port]
    end
  end

  # Adds a note to the graph without connection. The distance to any other node is infinite.
  #
  # @param [String] port_code the airport code.
  #
  # @return [void]
  #
  def add_node(port_code)
    @node_hash[port_code] = Hash.new(INFTY)
  end

  # Gets the URL addition for the JSON graph. The resulting string has every airport connection separated by commas and
  # using plus signs (+) for spaces. Examples: 'SCL-MEX', 'SCL-LIM,+LIM-BOG'
  #
  # @return [String] a string containing each airport connection.
  #
  def get_url_addition
    @connectors.get_connection_url
  end

  def get_closest_cities(city_code)
    @node_hash[city_code]
  end

  private
  # Creates the graph using the provided JSON file.
  #
  # @return [void]
  #
  def create_graph_from_json
    read_me = Reader.new
    graph_hash = read_me.get_graph_hash
    graph_hash.each do |route|
      add_connection(route['ports'][0], route['ports'][1], route['distance'])
    end
  end

  #
  # @param [String] node
  #
  # @param [Hash] node_hash
  #
  # @return [String]
  #
  def get_node_connections(node, node_hash)
    node_string = "\n{#{node}"
    unless node_hash.empty?
      node_string << add_to_string(node_hash)
    end
    node_string << '}'
  end

  # @param [Hash] node_hash
  #
  # @return [String]
  def add_to_string(node_hash)
    nodes_and_dist = ' => '
    node_hash.each do |port, dist|
      nodes_and_dist << "{#{port}: #{dist}}, "
    end
    nodes_and_dist[0..-3]
  end

  # Checks if at least one of the nodes does not exist in the graph.
  #
  # @param [String] first_port
  # @param [String] second_port
  def one_does_not_exist(first_port, second_port)
    !@node_hash.include? first_port or !@node_hash.include? second_port
  end

  # Adds a node to the graph if it does not exist yet.
  #
  # @param [String] port
  def add_if_non_existing(port)
    unless @node_hash.include? port
      add_node(port)
    end
  end
end