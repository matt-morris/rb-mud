require './character'
require './location'

class Game
  def initialize
    @locations = {
      home: Location.new('home', "it's where the heart is...")
    }
    @characters = {
      dubs: Character.new('dubs', 99, Float::INFINITY, location: @locations[:home])
    }
  end

  def login(client)
    client.puts "what is your name?"
    name = client.gets.chomp
    if @characters[name.to_sym]
      client.puts "welcome back, #{name.green}."
    else
      client.puts "#{'new character...'.yellow} #{name}!"
      @characters[name.to_sym] = Character.new(name, location: @locations[:home])
    end
    @characters[name.to_sym].name
  end

  def post(name, msg)
    puts "#{name.yellow} -> #{msg.blue}"
    actor = @characters[name.to_sym]
    tokens = msg.split
    command = tokens.shift
    tell(actor, tokens) if command == 'tell'
    look(actor, tokens) if command == 'look'
  end

  def tell(actor, tokens)
    target = @characters[tokens.shift.to_sym] if tokens.size > 0
    Server.post(actor.name, "you don't see #{target_name.red} here.") unless target
    Server.post(target.name, "#{actor.name.blue} tells you \"#{tokens.join(' ')}\"")
  end

  def look(actor, tokens)
    target = @characters[tokens.shift.to_sym] if tokens.size > 0
    target ||= actor.location
    # binding.pry
    Server.post(actor.name, target.description)
  end
end
