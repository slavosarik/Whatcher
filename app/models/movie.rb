require "json"
require "net/http"

class Movie < ActiveRecord::Base

  belongs_to :channel
  has_many :movie_genres
  has_many :genres, :through => :movie_genres

  def self.process_movie
    movie = find_movie("AZ-kvíz")
    persist_movie(movie)

    movie = find_movie("El Dorado")
    persist_movie(movie)

  end

  def self.find_movie(name)
    uri = URI.parse("http://csfdapi.cz/movie?search="+URI.escape(name))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    result = JSON.parse(http.request(request).body)

    uri = URI.parse("http://csfdapi.cz/movie/"+result.first["id"].to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    result = JSON.parse(http.request(request).body)

    #puts result["names"]["cs"]
    #puts result["runtime"]
    #puts result["year"]
    #puts result["plot"]
    #puts result["genres"]
    #puts result["rating"]
    #puts result["countries"]

    return result
  end

  def self.persist_movie(movie_data)

    movie = Movie.find_or_create_by!(
        name: movie_data["names"]["cs"],
        duration: movie_data["runtime"],
        year: movie_data["year"],
        description: movie_data["plot"],
        rating: movie_data["rating"],
    )

    movie_data["genres"].each do |g|
      movie.movie_genres.create!(
          genre_id: Genre.find_or_create_by!(
              genre_type: g
          ).id
      )
    end


  end


  #BACKUP PARSOVANIE
  def self.parse_movies(html)
    html = Faraday.get 'http://www.csfd.cz/film/273043-branky-body-vteriny/'
    doc = Nokogiri::HTML(html.body)

    doc.search('.page-content').each do |div|

      #puts div.search('#rating h2').text.to_i

      movie_origin = div.search('.origin').text.split(', ')

      Movie.create!(
          name: div.search('h1').text.strip,
          #genre: div.search('.genre').text,
          duration: movie_origin[2].split.first,
          year: movie_origin[1].to_i,
          description: div.search('.ct-related .content li')[0].text.strip,
          rating: div.search('#rating h2').text.to_i,
      #time: div.search('a')[0].text,
      )

    end
  end
end
