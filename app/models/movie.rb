class Movie < ActiveRecord::Base

  belongs_to :channel
  has_many :movie_genres
  has_many :genres, :through => :movie_genres

  def self.parse_movies
    html_csfd = Faraday.get 'http://www.csfd.cz/film/273043-branky-body-vteriny/'
    doc = Nokogiri::HTML(html_csfd.body)


    doc.search('.page-content').each do |div|

      #puts div.search('#rating h2').text.to_i

      movie_origin = div.search('.origin').text.split(', ')

      Movie.create!(
          name: div.search('h1').text.strip,
          genre: div.search('.genre').text,
          duration: movie_origin[2].split.first,
          year: movie_origin[1].to_i,
          description: div.search('.ct-related .content li')[0].text.strip,
          rating: div.search('#rating h2').text.to_i,
      #time: div.search('a')[0].text,
      )

    end

  end

end
