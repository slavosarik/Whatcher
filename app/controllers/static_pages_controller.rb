class StaticPagesController < ApplicationController
  def index
    #@programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => Time.now.strftime("%Y-%m-%d")}).order("rating DESC").first(4);
    @programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => "2014-08-25"}).order("rating DESC").first(4)
  end

end
