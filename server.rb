require "socket"

class Server
  def initialize(port, host)
    @connections = {}
    @server = TCPServer.open(host, port)
    run
  end

  private
 
  def run
    loop do
      Thread.start(@server.accept) do |client|
        client.puts "welcome to rb-mud..."
        addr = Socket.unpack_sockaddr_in(client.getpeername)
        client_id = "#{addr.last}:#{addr.first}".to_sym
        @connections[client_id] = client
        listen_user_messages(client_id, client)
      end
    end.join
  end
 
  def listen_user_messages(client_id, client)
    loop do
      msg = client.gets.chomp
      puts "#{client_id}: #{msg}"
    end
  end
end
 
Server.new(3333, "localhost")
