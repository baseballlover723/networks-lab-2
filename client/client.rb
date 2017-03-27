require 'socket'

PORT = 3000

def input_loop
  while true
    print('input> ')
    input = gets.chomp
    socket = TCPSocket.new 'localhost', PORT
    trap('INT') { puts 'Shutting down.'; socket.close; exit }

    command, *args = parse_command input
    socket.close and next unless validate_command(command, args)
    send socket, input do
      handle_response socket, command, args
    end
    socket.close # close socket when done
    puts "closed socket\n\n"
  end
end

def send(socket, input)
  input += "\0"
  puts "sending '#{input}'"
  socket.write(input)
  yield
end

def handle_response(socket, command, args)
  puts 'server response'
  response_code = socket.gets.to_i
  unless response_code == 200
    return puts "#{response_code} #{socket.gets}"
  end
  file_path = args.first
  print "What directory would you like to store '#{file_path}' (default: default/): "
  directory = gets.chomp
  directory = "default" if directory.empty?
  File.open(directory + '/' + file_path, 'w') do |file|
    while line = socket.gets # Read lines from socket
      file.puts(line)
    end
  end
end

def parse_command(input)
  input.split(" ")
end

def validate_command(command, args)
  case command
    when "uTake"
      true
    else
      true
  end
end

input_loop
