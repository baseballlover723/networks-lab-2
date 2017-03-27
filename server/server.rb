require 'socket'

Thread.abort_on_exception=true

PORT = 3000
CHUNK_SIZE = 4

class String
  def underscore
    gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        downcase
  end
end

class Server
  def start
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
    command, *args = parse_command read(client)
    puts "client sent '#{command}' with '#{args}'"
    if respond_to? command.to_sym
      send(command, client, args)
    else
      puts "501 Command '#{command}' is not supported"
      client.puts 501
      client.puts "Command '#{command}' is not supported"
    end
  end

  def read(client)
    data = ""
    while tmp = client.recv(CHUNK_SIZE)
      data += tmp
      break if tmp.end_with? "\0"
    end
    data.chomp("\0")
  end

  def parse_command(input)
    inputs = input.split(" ")
    inputs[0] = inputs[0].underscore
    inputs
  end

  def send_400(client)
    puts "400 Bad Request"
    client.puts(400)
    client.puts("Bad Request")
  end

  def send_404(client, path)
    puts "404 File Not Found at 'store/#{path}'"
    client.puts(404)
    client.puts("File Not Found at '#{path}'")
  end

  def i_want(client, args)
    return send_400 client unless args.size == 1
    path = "store/" + args.first
    return send_404 client, path.gsub("store/", "") unless File.file?(path)
    client.puts(200)
    file = File.open(path, "rb")
    client.puts file.read
  end

  def u_take(client, args)
    return send_400 client unless args.size == 1
    file_name = args.first
    client.puts(200)
    file_contents = read(client)
    begin
      File.open('store/' + file_name, 'w') do |file|
        file.puts(file_contents)
      end
      client.puts(200)
    rescue
      client.puts(500)
    end
  end
end

Server.new.start
