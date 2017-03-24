require 'socket'

s = TCPSocket.new 'localhost', 3000

while true
  while line = s.gets # Read lines from socket
    puts line # and print them
  end
end

s.close # close socket when done

