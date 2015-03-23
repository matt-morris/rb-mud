class Location
  attr_accessor :name, :description, :contents, :exits

  def initialize(name, description, contents = [], exits = {})
    @name, @description = name, description
    @contents, @exits = contents, exits
  end
end
