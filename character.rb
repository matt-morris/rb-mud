class Character
  attr_accessor :name, :description, :level, :hp, :location

  def initialize(name, level = 1, hp = 1, **options)
    @name, @level, @hp = name, level, hp
    @description = options[:description] || "a generic character."
    set_location(options[:location])
  end

  def set_location(location)
    @location.contents.reject! { |c| c == self } unless @location.nil?
    @location = location
    location.contents << self unless location.nil?
  end
end
