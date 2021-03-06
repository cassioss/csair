require 'json'

# Module that reads all the data present in the JSON file used as resource.
#
# @author Cassio dos Santos Sousa
# @version 1.1
# @since 1.0
#
class Reader

  #
  # @return [void]
  #
  def initialize(json_file_name)
    @json_data_hash = data_hash_from_json(json_file_name)
  end

  #
  # @return [Array]
  #
  def get_graph_hash
    @json_data_hash['routes']
  end

  #
  # @return [Array]
  #
  def get_metro_hash
    @json_data_hash['metros']
  end

  #
  # @return [Array]
  #
  def get_data_sources
    @json_data_hash['data sources']
  end

  private

  # Reads a specific JSON file to obtain CSAir data.
  #
  # @return [Hash]
  #
  def data_hash_from_json(json_file_name)
    my_path = File.dirname(__FILE__)
    path_to_json = File.join(my_path, '..', '..', 'resources', json_file_name)
    json_file = File.read(path_to_json)
    JSON.parse(json_file)
  end

end