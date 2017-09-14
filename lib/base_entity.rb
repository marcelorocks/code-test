class BaseEntity

  def initialize(atts = {})
    atts.map{|k, v| self.send("#{k}=", v) if respond_to?("#{k}=")}
  end

end
