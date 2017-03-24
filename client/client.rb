require 'socket'

PORT = 3000

def input_loop
  while true
    print('input> ')
    input = gets.chomp
    socket = TCPSocket.new 'localhost', PORT
    trap('INT') { puts 'Shutting down.'; socket.close; exit }

    send socket, input
    handle_response(socket)
    socket.close # close socket when done
    puts "closed socket\n\n"

  end
end

def send(socket, input)
  input += "\0"
  puts "sending '#{input}'"
  socket.write(input)
end

def handle_response(socket)
  puts 'server response'
  while line = socket.gets # Read lines from socket
    puts line # and print them
  end
end


input_loop
