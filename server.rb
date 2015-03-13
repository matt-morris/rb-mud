require "socket"

class Server
  def initialize(port, host)
    @server = TCPServer.open(host, port)
    run
  end

  private
 
  def run
    loop do
      Thread.start(@server.accept) do |client|
        client.puts "welcome to rb-mud..."
        listen_user_messages(client)
      end
    end.join
  end
 
  def listen_user_messages(client)
    loop do
      msg = client.gets.chomp
      puts "received: #{msg}"
    end
  end
end
 
Server.new(3333, "localhost")
