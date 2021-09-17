require 'sinatra'
require 'open-uri'
require_relative 'generator'

$index = ""
$xml = { timestamp: Time.at(0), data: "" }

configure do
  set :lock, true
end

helpers do
  def update_xml_index(io)
    $xml[:data] = io.read
    $xml[:timestamp] = Time.now
    gen = Generator.new
    io = StringIO.new($index, "w")
    gen.($xml[:data], io)
  end
end

before do
  if (Time.now - $xml[:timestamp]) >= 60
    URI.open('http://localhost:7144/admin?cmd=viewxml') do |io|
      update_xml_index(io)
    end
  end
end

get '/' do
  redirect to('/index.html')
end

get '/index.txt' do
  content_type 'text/plain; charset=utf-8'
  $index
end

post '/statxml' do
  update_xml_index(request.body)
  status 200
  ""
end

get '/statxml' do
  content_type 'application/xml'
  $xml[:data]
end

run Sinatra::Application
