require 'socket'

PORT = 3000
CHUNK_SIZE = 4

def main_loop
  server = TCPServer.new PORT
  trap('INT') { puts 'Shutting down.'; server.close; exit }

  puts "server started on port #{PORT}"
  loop do
    Thread.start(server.accept) do |client|
      handle_connection client
      client.close
    end
  end
end

def handle_connection(client)
  puts "\nnew connection"
  input = parse_client_input client
  puts "client sent '#{input}'"
  client.puts 'Hello !'
  client.puts "Time is #{Time.now}"
end

# TODO use read once we know how many bytes to read
def parse_client_input(client)
  data = ""
  while tmp = client.recv(CHUNK_SIZE)
    puts tmp
    data += tmp
    break if tmp.end_with? "\0"
  end
  data.chomp("\0")
end

main_loop
