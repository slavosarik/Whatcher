class StaticPagesController < ApplicationController
  def index
    #@day = params[:day] || Date.today
    @program_time = params[:program_time]

    case @program_time
      when 'now'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where("duration > 60"). where(day: Date.today, scheduled_time_start: (Time.now + 1.hour)..(Time.now + 3.hour)).
            order("rating DESC").first(4);
      when 'today'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where("duration > 60"). where(programs: {:day => Date.today}).order("rating DESC").first(4);
      when 'tomorow'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where("duration > 60"). where(programs: {:day => Date.today + 1.day}).order("rating DESC").first(4);
      when 'week'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where("duration > 60"). where(programs: {day: Date.today..(Date.today + 7.day)}).order("rating DESC").first(4);
      when 'archiv'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where("duration > 60"). where(programs: {:day => Date.today}).order("rating DESC").first(4);
      else
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where("duration > 60"). where(programs: {:day => Date.today}).order("rating DESC").first(4);
    end

    @genre_list = Genre.all

    #@programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => @day}).order("rating DESC").first(4);
    #@programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => "2014-08-25"}).order("rating DESC").first(4)
  end

end
