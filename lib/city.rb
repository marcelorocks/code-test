class City < BaseEntity

  include BasePopulation

  attr_accessor :name, :state, :population

  def to_h
    {
      name: name,
      population: population
    }
  end

end
