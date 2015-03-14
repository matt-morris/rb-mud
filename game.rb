class Game
  def initialize
    @characters = {}
  end

  def post(id, msg)
    puts "#{id} -> #{msg}"
  end
end
