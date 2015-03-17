require "socket"
require "colorize"

class Server
  def initialize(port, host, system)
    @system = system
    @connections = {}
    @server = TCPServer.open(host, port)
    puts "listening on #{host}:#{port}..."
    run
  end

  def push_user_message_to_client(client_id, msg)
    @connections[client_id][:client].puts(msg)
  end

  private
 
  def run
    loop do
      Thread.start(@server.accept) do |client|
        client.puts "welcome to #{'rb-mud'.red}..."
        addr = Socket.unpack_sockaddr_in(client.getpeername)
        client_id = "#{addr.last}:#{addr.first}".to_sym
        name = @system.game.login(client)
        @connections[client_id] = { name: name, client: client }
        listen_user_messages(client_id)
      end
    end.join
  end
 
  def listen_user_messages(client_id)
    loop do
      msg = @connections[client_id][:client].gets.chomp
      @system.game.post(@connections[client_id][:name], msg)
    end
  end
end
