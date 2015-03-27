require './character'
require './location'
require './item'

class Game
  def initialize
    @locations = {
      home: Location.new('home', "it's where the heart is...",
                         exits: { north: Location.new('office', "a small, utilitarian room.",
                                                       contents: [Item.new('coin', 'a shiny silver coin glistens here.')]) })
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
    travel(actor, tokens) if command == 'travel'
    travel(actor, tokens) if command == 'go'
  end

  private

  def tell(actor, tokens)
    target_name = tokens.shift
    if target_name
      target = @characters[target_name.to_sym]
      target = nil unless actor.location.contents.select { |c| c == target }.size > 0
    end
    Server.post(actor.name, "you don't see #{target_name.red} here.") unless target
    Server.post(target.name, "#{actor.name.blue} tells you \"#{tokens.join(' ')}\"")
  end

  def look(actor, tokens)
    if tokens.size > 0
      pattern = tokens.shift
      target = @characters[pattern.to_sym]
      target ||= actor.location.contents.select { |c| c.name == pattern }.first
    end
    target ||= actor.location
    # binding.pry
    Server.post(actor.name, "#{target.name.blue}: #{target.description}")
    if target.is_a? Location
      target.contents.each do |c|
        Server.post(actor.name, "#{c.name.blue}: #{c.description}")
      end
    end
  end

  def travel(actor, tokens)
    unless tokens.size > 0
      Server.post(actor.name, "need a little #{'more info'.blue} than that...")
    else
      target = actor.location.exits[tokens.shift.to_sym]
      actor.set_location(target) if target
      look(actor, '')
    end
  end
end
