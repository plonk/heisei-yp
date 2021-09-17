require 'nokogiri'
require_relative 'channel_info'

class Generator
  def format_time(total_seconds)
    h = total_seconds / 3600
    m = total_seconds % 3600 / 60
    "%02d:%02d" % [h, m]
  end

  def make_status_line(doc)
    time = Time.now.strftime("%Y/%m/%d %H:%M:%S %p %Z")
    uptime = format_time( doc.css("servent")[0].attr("uptime").to_i )

    info = ChannelInfo.new
    info.name = "平成YP◆Status"
    info.description = "更新時刻: #{time} 稼働時間: #{uptime}"
    info.listeners = "-9"
    info.relays = "-9"
    info.ip = ""
    info.id = "00000000000000000000000000000000"
    info.type = "RAW"
    return info
  end

  def call(input, output)
    doc = Nokogiri::XML(input)

    doc.css("channels_found > channel").each do |elt|
      next if elt.css('host').size == 0

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
      output.puts info.to_line
    end

    info = make_status_line(doc)
    output.puts info.to_line
  end
end
