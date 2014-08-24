class Program < ActiveRecord::Base
  belongs_to :channel
  belongs_to :movie

  def self.parse_programs

    #
    #TU SA SPUSTA FUNKCIA !!! - v rails-console: Program.parse_programs
    #


    #PARSOVANIE PROGRAMU
    #html_tv = Faraday.get 'http://tv-program.aktuality.sk/dnes/cely-den/'
    html_tv = Faraday.get 'http://tv-program.aktuality.sk/zajtra/'
    doc = Nokogiri::HTML(html_tv.body)

    program_day = doc.search('.head-days a .head-day-subtitle')[1].text.strip

    #PREHLADAVANIE TELEVIZNYCH STANIC
    doc.search('.tv-stations .tv-station').each do |station|

      #ZISKAVANIE NAZVVU TELEVIZNEJ STANICE
      station_name = station.search('.station-head h2 a').text
      #puts "Station: " + station_name


      #ULOZENIE STANICE DO DATABAZY
      Channel.find_or_create_by!(
          name: station_name
      )

      #ZISKAVANIE UDAJOV O VYSIELANOM PROGRAME
      prog = station.search('.programme')
      info = station.search('script')

      #PREHLADAVANIE PROGRAMOV
      prog.each_with_index do |item, index|
        #ZISKAVANIE NAZVU PROGRAMU
        program_info = info[index+1].text.match("'.*'").to_s.split(/','/)
        program_name = program_info[0]
        program_name[0] = ''

        #ZISKAVANIE INFORMACII O PROGRAME
        program_about = program_info[1]

        #ZISKAVANIE VYSIELACIEHO CASU PROGRAMU
        prog_time = program_info[2].split(/ - /)
        prog_time_start = prog_time[0]
        prog_time_end = prog_time[1]

        #puts "Nazov: " + program_name + ", zaciatok: " + prog_time_start + ", koniec: " + prog_time_end + ", detail: " + program_about + "\n\n"

        #VYHLADAVANIE FIMU NA CSFD
        movie_data = Movie.find_movie(program_name)

        if movie_data != nil

          #ULOZENIE FILMU DO DATABAZY
          movie = persist_and_retrieve_movie(movie_data)

          #ULOZENIE PROGRAMU DO DATABAZY
          movie.programs.find_or_create_by!(
              channel_id: Channel.find_or_create_by!(name: station_name).id,
              scheduled_time_start: prog_time_start,
              scheduled_time_end: prog_time_end,
              day: program_day
          )
        end
      end
    end
  end

  def self.persist_and_retrieve_movie(movie_data)

    if movie_data["runtime"].to_s == ''
      movie_time = ""
    else
      if movie_data["runtime"].include?("x")
        movie_time = movie_data["runtime"][0..-4].split("x")[1]
      else
        movie_time = movie_data["runtime"][0..-4]
      end
    end

    #puts "INFOOOOOOO: "
    #puts "\n"
    #puts movie_data["names"]["cs"]
    #puts "\n"
    #puts movie_data["runtime"]
    #puts "\n"
    #puts movie_time
    #puts "\n"

    #VYTVORENIE A ULOZENIE FILMU DO DATABAZY
    movie = Movie.find_or_create_by!(
        name: movie_data["names"]["cs"],
        duration: movie_time,
        year: movie_data["year"],
        description: movie_data["plot"],
        rating: movie_data["rating"],
    )

    #VYTVORENIE ZANRU K FILMU
    begin
      movie_data["genres"].each do |g|
        movie.movie_genres.find_or_create_by!(
            genre_id: Genre.find_or_create_by!(
                genre_type: g
            ).id
        )
      end
    rescue NoMethodError
    end

    return movie
  end


  def self.get_4_top_ratings

    #vybrat vsetky filmy, ktore idu dnes podla navyssieho ratingu
    # Movie.joins(:programs).where(programs: {:day => Time.now.strftime("%Y-%m-%d")}).order("rating DESC").first(4)

    program_list = Program.joins(:movie).where(programs: {:day => Time.now.strftime("%Y-%m-%d")}).order("rating DESC").first(4)

    program_list.each do |p|
      puts "Tv Stanica: " + p.channel.name.to_s+"\n"
      puts "Nazov: " + p.movie.name.to_s+"\n"
      puts "Zaciatok: " + p.scheduled_time_start.strftime("%H:%M").to_s+"\n"
      puts "Koniec: " + p.scheduled_time_end.strftime("%H:%M").to_s+"\n"
      puts "Rating: " + p.movie.rating.to_s + "\n"
      puts "Rok: " + p.movie.year.to_s + "\n"
      puts "Dlzka: " + p.movie.duration.to_s + " min\n"
      puts "Zaner: "

      genres = Array.new
      p.movie.movie_genres.each do |m_genre|
        genres.push m_genre.genre.genre_type
      end
      puts genres.to_s

      puts "\n"
    end
    nil
  end

end