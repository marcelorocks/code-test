module BasePopulation

  def add_population_from_zipcode(zipcode)
    before_add_population(zipcode) if respond_to?(:before_add_population)
    self.population ||= 0
    self.population += zipcode.pop.to_i
    after_add_population(zipcode) if respond_to?(:after_add_population)
  end

end
