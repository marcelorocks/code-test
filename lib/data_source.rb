class DataSource

  attr_accessor :source_url, :raw_data, :zip_codes, :states, :cities

  MAJOR_POPULATION_THRESHOLD = 10000000

  def initialize(source_url = nil)
    self.zip_codes  = []
    self.states     = []
    self.cities     = []
    self.source_url = source_url

    reload_from_source!
  end

  def reload_from_source!
    # Fetches json data, loads objects of type BaseEntity
    begin
      self.raw_data = RestClient.get(source_url)
      self.zip_codes = self.raw_data.split("\n").inject([]){|array, line| array << JSON.parse(line); array}.map{|hash| ZipCode.new(hash.merge("city" => hash["city"].titleize))}
    rescue
      puts "Unable to load data from the source: (#{source_url})" unless source_url.nil?
    end
  end

  def load_states
    self.states = self.zip_codes.map.inject({}) do |hash, zip_code|
      hash[zip_code.state] ||= State.new(name: zip_code.state)
      hash[zip_code.state].add_population_from_zipcode(zip_code)
      hash
    end
  end

  def major_states
    self.states.values.reject{|s| s.population < MAJOR_POPULATION_THRESHOLD}.map(&:to_h)
  end

  def average_population_for_state(state)
    states[state].to_h
  end

  def boundary_cities_for_state(state)
    states[state].to_h(with_boundary_cities: true)
  end

end
