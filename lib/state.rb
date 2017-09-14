class State < BaseEntity

  include BasePopulation

  attr_accessor :name, :population, :cities

  def find_city(city_name)
    self.cities ||= {}
    self.cities[city_name.downcase]
  end

  def add_city_from_zipcode(zipcode)
    city = find_city(zipcode.city)
    if city.nil?
      city = City.new(name: zipcode.city, state: self)
      self.cities[city.name.downcase] = city
    end
    city
  end

  def after_add_population(zipcode)
    add_city_population_from_zipcode(zipcode)
  end

  def add_city_population_from_zipcode(zipcode)
    city = add_city_from_zipcode(zipcode)
    city.add_population_from_zipcode(zipcode)
  end

  def average_population
    (population.to_f / cities_count.to_f).round
  end

  def cities_count
    cities.keys.count
  end

  def cities_by_population
    @cities_by_population ||= self.cities.values.sort_by{|c| c.population}
  end

  def biggest_city
    cities_by_population.last
  end

  def smallest_city
    cities_by_population.first
  end

  def to_h(options = {})
    data = {
      name: name,
      population: population,
      cities: cities_count,
      average_population: average_population
    }

    if options[:with_boundary_cities]
      data.merge!({
        biggest_city: biggest_city.to_h,
        smallest_city: smallest_city.to_h
      })
    end

    data
  end

end
