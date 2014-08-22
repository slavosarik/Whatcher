class Channel < ActiveRecord::Base
  has_many :programs
  has_many :movies, :through => :programs


  def self.parse_genres

    #http://www.csfd.cz/filmoteky/

  end
end

