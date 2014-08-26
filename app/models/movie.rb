require "json"
require "net/http"

class Movie < ActiveRecord::Base
  has_many :programs
  has_many :channels, :through => :programs
  has_many :movie_genres
  has_many :genres, :through => :movie_genres

  def self.find_movie(name)
    @prem = true
    while @prem do
      begin
        uri = URI.parse("http://csfdapi.cz/movie?search="+URI.escape(name))
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        result = JSON.parse(http.request(request).body)
        sleep 1
        uri = URI.parse("http://csfdapi.cz/movie/"+result.first["id"].to_s)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        result = JSON.parse(http.request(request).body)
        sleep 1
        @prem = false
      rescue JSON::ParserError
        #puts e.message
        sleep 25
      rescue NoMethodError
        result = nil
        @prem = false
      end
    end

    #puts result["names"]["cs"]
    #puts result["runtime"]
    #puts result["year"]
    #puts result["plot"]
    #puts result["genres"]
    #puts result["rating"]
    #puts result["countries"]

     return result
  end
end
