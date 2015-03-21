class Character
  attr_accessor :name, :description, :level, :hp, :location

  def initialize(name, level = 1, hp = 1, **options)
    @name, @level, @hp = name, level, hp
    @description = options[:description] || "a generic character."
    @location = options[:location]
  end
end
