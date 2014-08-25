class StaticPagesController < ApplicationController
  def index
    @day = params[:day] || Date.today
    @programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => @day}).order("rating DESC").first(4);
    #@programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => "2014-08-25"}).order("rating DESC").first(4)
  end

end
