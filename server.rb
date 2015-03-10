require 'socket'

class Server
  def initialize(port=3333, host='localhost')
    @server = TCPServer.open(host, port)
    @connections = {}
    @clients = {}
  end

  def run
    loop do
      Thread.start(@server.accept) do |client|
        request = client.gets.chomp
        puts "received: #{request}"
      end
    end
  end
end

server = Server.new.run
