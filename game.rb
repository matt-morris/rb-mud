require './character'

class Game
  def initialize
    @characters = {
      dubs: Character.new('dubs')
    }
  end

  def login(name)
    @characters[name.to_sym]
  end

  def post(id, msg)
    puts "#{id} -> #{msg}"
  end
end
