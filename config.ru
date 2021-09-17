require 'sinatra'
require_relative 'generator'

configure do
  set :lock, true
end

$index = ""
$xml = ""

get '/index.txt' do
  content_type 'text/plain; charset=utf-8'
  $index
end

post '/statxml' do
  $xml = request.body.read
  gen = Generator.new
  io = StringIO.new($index, "w")
  gen.($xml, io)
  status 200
puts $index
  ""
end

get '/statxml' do
  content_type 'application/xml'
  $xml
end

run Sinatra::Application
