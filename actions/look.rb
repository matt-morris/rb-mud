module Actions
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
end
