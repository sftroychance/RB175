=begin
Ruby server walkthrough.
=end

require 'socket'

server = TCPServer.new('localhost', 3003)

def parse_request(request_line)
  http_method, remainder = request_line.split[0..1]
  path, query = remainder.split('?')

  params = query.split('&')
                .each_with_object({}) do |p, hash|
    k, v = p.split('=')
    hash[k] = v
  end

  [http_method, path, params]
end

loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  http_method, path, params = parse_request(request_line)

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls</h1>"
  rolls.times do |roll|
    client.puts "<p>#{roll + 1}: #{rand(1..sides)}</p>"
  end

  client.puts "</body>"
  client.puts "</html>"
  client.close
end