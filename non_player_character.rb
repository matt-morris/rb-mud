class NonPlayerCharacter
  attr_accessor :name, :level, :hp

  def initialize(name, level = 1, hp = 1)
    @name, @level, @hp = name, level, hp
  end
end
