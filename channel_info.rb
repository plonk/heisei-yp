class ChannelInfo
  attr_accessor :name, :id, :ip, :url, :genre, :description,
       :listeners, :relays, :bitrate, :type,
       :track_artist, :track_album,
       :track_title, :track_contact,
       :name_url_encoded, :time,
       :status, :comment, :direct

  def initialize(fields = {})
    @name             = fields[:name] || ""
    @id               = fields[:id] || ""
    @ip               = fields[:ip] || "0.0.0.0:0"
    @url              = fields[:url] || ""
    @genre            = fields[:genre] || ""
    @description      = fields[:description] || ""
    @listeners        = fields[:listeners] || "-1"
    @relays           = fields[:relays] || "-1"
    @bitrate          = fields[:bitrate] || "0"
    @type             = fields[:type] || ""
    @track_artist     = fields[:track_artist] || ""
    @track_album      = fields[:track_album] || ""
    @track_title      = fields[:track_title] || ""
    @track_contact    = fields[:track_contact] || ""
    @name_url_encoded = fields[:name_url_encoded] || ""
    @time             = fields[:time] || "00:00"
    @status           = fields[:status] || "click"
    @comment          = fields[:comment] || ""
    @direct           = fields[:direct] || "0"
  end

  def to_line
    [:name, :id, :ip, :url, :genre, :description,
     :listeners, :relays, :bitrate, :type,
     :track_artist, :track_album,
     :track_title, :track_contact,
     :name_url_encoded, :time,
     :status, :comment, :direct].map { |key|
      clean(self.__send__(key))
    }.join("<>")
  end

  def clean(str)
    str.gsub(/[\x00-\x1f]/, ' ').gsub(/ +/, ' ').strip
  end

  def escape(str)
    str.gsub(/&|<|>/) { |ch|
      case ch
      when "&" then "&amp;"
      when "<" then "&lt;"
      when ">" then "&gt;"
      end
    }
  end
end
