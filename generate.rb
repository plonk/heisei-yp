require 'nokogiri'
require 'open-uri'
require_relative 'channel_info'

def format_time(total_seconds)
  h = total_seconds / 3600
  m = total_seconds % 3600 / 60
  "%02d:%02d" % [h, m]
end

YP_ENDPOINT = "49.212.151.50:7146"

def make_status_line
  io = URI.open("http://#{YP_ENDPOINT}/html/ja/index.html")
  doc = Nokogiri::HTML(io)
  uptime = doc.css("td")[9].text

  info = ChannelInfo.new
  info.name = "平成YP◆Status"
  time = Time.now.strftime("%Y/%m/%d %H:%M:%S %p %Z")
  info.description = "更新時刻: #{time} 稼働時間: #{uptime}"
  info.listeners = "-9"
  info.relays = "-9"
  info.ip = ""
  info.id = "00000000000000000000000000000000"
  info.type = "RAW"
  return info
end

io = URI.open("http://#{YP_ENDPOINT}/admin?cmd=viewxml")
doc = Nokogiri::XML(io)

doc.css("channels_found > channel").each do |elt|
  data = ["name","id", "bitrate", "type", "genre", "desc", "url", "age", "comment"]
         .map { |key| [key, elt.attr(key)] }.to_h

  info = ChannelInfo.new
  info.name = data['name']
  info.id = data['id']
  info.bitrate = data['bitrate']
  info.type = data['type']
  info.genre = data['genre']
  info.description = data['desc']
  info.url = data['url']
  info.time = format_time(data['age'].to_i)
  info.comment = data['comment']

  tracker = elt.css("host").last
  hits = elt.css("hits").first
  info.listeners = hits.attr('listeners')
  info.relays = hits.attr('relays')
  info.direct = tracker.attr("direct")
  if hits.attr("firewalled") == "1"
    info.ip = ""
  else
    info.ip = tracker.attr("ip")
  end
  puts info.to_line
end

info = make_status_line
puts info.to_line
