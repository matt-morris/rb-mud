require "socket"
require "colorize"

class Server
  def initialize(port, host)
    @@connections = {}
    @server = TCPServer.open(host, port)
    puts "listening on #{host}:#{port}..."
    run
  end

  def self.push_user_message_to_client(name, msg)
    # binding.pry
    @@connections.invert(name: name)[:client_id].puts(msg)
  end

  private
 
  def run
    loop do
      Thread.start(@server.accept) do |client|
        client.puts "welcome to #{'rb-mud'.red}..."
        addr = Socket.unpack_sockaddr_in(client.getpeername)
        client_id = "#{addr.last}:#{addr.first}".to_sym
        name = $game.login(client)
        @@connections[client_id] = { name: name, client: client }
        # binding.pry
        Server.listen_user_messages(client_id)
      end
    end.join
  end
 
  def self.listen_user_messages(client_id)
    loop do
      # binding.pry
      msg = @@connections[client_id][:client].gets.chomp
      $game.post(@@connections[client_id][:name], msg)
    end
  end
end
