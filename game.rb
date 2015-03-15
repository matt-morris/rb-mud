require './character'

class Game
  def initialize
    @characters = {
      dubs: Character.new('dubs', 99, Float::INFINITY)
    }
  end

  def login(client)
    client.puts "what is your name?"
    name = client.gets.chomp
    if @characters[name.to_sym]
      client.puts "login successful".green
    else
      client.puts "new character...".yellow
      @characters[name.to_sym] = Character.new(name)
    end
    @characters[name.to_sym].name
  end

  def post(name, msg)
    puts "#{name} -> #{msg}"
  end
end
