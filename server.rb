require "socket"
require "colorize"

class Server
  def initialize(port, host)
    @connections = {}
    @server = TCPServer.open(host, port)
    puts "listening on #{host}:#{port}..."
    run
  end

  def push_user_message_to_client(name, msg)
    # @connections[client_id][:client].puts(msg)
    @connections.invert(name: name)[:client_id].puts(msg)
  end

  private
 
  def run
    loop do
      Thread.start(@server.accept) do |client|
        client.puts "welcome to #{'rb-mud'.red}..."
        addr = Socket.unpack_sockaddr_in(client.getpeername)
        client_id = "#{addr.last}:#{addr.first}".to_sym
        # binding.pry
        name = $game.login(client)
        @connections[client_id] = { name: name, client: client }
        listen_user_messages(client_id)
      end
    end.join
  end
 
  def listen_user_messages(client_id)
    loop do
      msg = @connections[client_id][:client].gets.chomp
      $game.post(@connections[client_id][:name], msg)
    end
  end
end
