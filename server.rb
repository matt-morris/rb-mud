require "socket"
require "colorize"

class Server
  def initialize(port, host, game)
    @@game = game
    @@connections = {}
    @server = TCPServer.open(host, port)
    puts "listening on #{host.blue}:#{port.to_s.magenta}..."
    run
  end

  def self.post(name, msg)
    connection = Server.find_connection(name)
    connection.puts msg if connection
  end

  private

  def self.find_connection(name)
    connection = nil
    @@connections.select { |_, conn| connection = conn[:client] if conn[:name] == name }
    connection
  end

  def run
    loop do
      Thread.start(@server.accept) do |client|
        client.puts "welcome to #{'rb-mud'.red}..."
        addr = Socket.unpack_sockaddr_in(client.getpeername)
        client_id = "#{addr.last}:#{addr.first}".to_sym
        name = @@game.login(client)
        @@connections[client_id] = { name: name, client: client }
        Server.listen(client_id)
      end
    end.join
  end
 
  def self.listen(client_id)
    loop do
      msg = @@connections[client_id][:client].gets.chomp
      @@game.post(@@connections[client_id][:name], msg)
    end
  end
end
