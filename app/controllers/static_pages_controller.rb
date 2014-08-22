class StaticPagesController < ApplicationController
  def index
    #@programs = Program.joins(:movie).where(programs: {:day => Time.now.strftime("%Y-%m-%d")}).order("rating DESC").first(4)
    @programs = Program.joins(:movie).where(programs: {:day => "2014-08-22"}).order("rating DESC").first(4)
  end

end
