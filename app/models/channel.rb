class Channel < ActiveRecord::Base
  has_many :movie_genres
  has_many :movies, :through => :movie_genres

  def self.parse_genres

    #http://www.csfd.cz/filmoteky/

  end
end

