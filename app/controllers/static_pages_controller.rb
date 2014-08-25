class StaticPagesController < ApplicationController
  def index
    #@day = params[:day] || Date.today
    @program_time = params[:program_time]

    puts "Cas: "
    puts Time.now
    puts "\n"

    puts Time.now - 1.hour
    puts "\n"


    case @program_time
      when 'now'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where(programs: {:day => Date.today}, scheduled_time_start: (Time.now - 1.hour)..Time.now).
            order("rating DESC").first(4);
      when 'today'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where(programs: {:day => Date.today}).order("rating DESC").first(4);
      when 'tomorow'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where(programs: {:day => Date.today + 1.day}).order("rating DESC").first(4);
      when 'week'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where(programs: {:day => Date.today}).order("rating DESC").first(4);
      when 'archiv'
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where(programs: {:day => Date.today}).order("rating DESC").first(4);
      else
        @programs = Program.joins(:movie).
            where.not(movies: {:rating => nil}).where(programs: {:day => Date.today}).order("rating DESC").first(4);
    end

    #@programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => @day}).order("rating DESC").first(4);
    #@programs = Program.joins(:movie).where.not(movies: {:rating => nil}).where(programs: {:day => "2014-08-25"}).order("rating DESC").first(4)
  end

end
