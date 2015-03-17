require './character'

class Game
  def initialize(system)
    @system = system
    @characters = {
      dubs: Character.new('dubs', 99, Float::INFINITY)
    }
  end

  def login(client)
    client.puts "what is your name?"
    name = client.gets.chomp
    if @characters[name.to_sym]
      client.puts "welcome back, #{name.green}."
    else
      client.puts "#{'new character...'.yellow} #{name}!"
      @characters[name.to_sym] = Character.new(name)
    end
    @characters[name.to_sym].name
  end

  def post(name, msg)
    puts "#{name} -> #{msg}"
    tokens = msg.split
    command = tokens.shift
    tell tokens if command == 'tell'
  end

  def tell(tokens)
    target_name = tokens.shift
    target = @characters[target_name.to_sym]
    # client.puts "i don't see #{target_name.red} here." unless target

  end
end
