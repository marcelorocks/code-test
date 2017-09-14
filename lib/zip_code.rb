class ZipCode < BaseEntity

  attr_accessor :_id, :city, :loc, :pop, :state

  def to_h
    {
      id: _id,
      city: city,
      state: state,
      loc: loc,
      pop: pop
    }
  end

end
