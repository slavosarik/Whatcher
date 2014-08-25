class Channel < ActiveRecord::Base
  has_many :programs
  has_many :movies, :through => :programs
end

