class Program < ActiveRecord::Base
  belongs_to :channel
  belongs_to :movie

  def self.parse_programs

    #
    #TU SA SPUSTA FUNKCIA !!! - v rails-console: Program.parse_programs
    #

    #PARSOVANIE PROGRAMU
    #html_tv = Faraday.get 'http://tv-program.aktuality.sk/dnes/cely-den/'
    channell = [#'http://tv-program.aktuality.sk/stanica/jednotka/'
                #'http://tv-program.aktuality.sk/stanica/joj/',
                #'http://tv-program.aktuality.sk/stanica/plus/',
                #'http://tv-program.aktuality.sk/stanica/ct1/',
                #'http://tv-program.aktuality.sk/stanica/nova/',
                #'http://tv-program.aktuality.sk/stanica/dajto/',
                #'http://tv-program.aktuality.sk/stanica/dvojka/',
                #'http://tv-program.aktuality.sk/stanica/ct2/',
                #'http://tv-program.aktuality.sk/stanica/hbo/',
                #'http://tv-program.aktuality.sk/stanica/markiza/',
                #'http://tv-program.aktuality.sk/stanica/doma/',
                #'http://tv-program.aktuality.sk/stanica/prima/',
                'http://tv-program.aktuality.sk/stanica/prima-cool/',
                'http://tv-program.aktuality.sk/stanica/prima-love/',
                'http://tv-program.aktuality.sk/stanica/hbo2/',
                'http://tv-program.aktuality.sk/stanica/hbo-comedy/',
                'http://tv-program.aktuality.sk/stanica/film-plus/',
                'http://tv-program.aktuality.sk/stanica/filmbox/',
                'http://tv-program.aktuality.sk/stanica/film-europe/',
                'http://tv-program.aktuality.sk/stanica/cinemax/',
                'http://tv-program.aktuality.sk/stanica/mgm/',
                'http://tv-program.aktuality.sk/stanica/universal-channel/'
                ]

    channell.each do |chann|
      html_tv = Faraday.get chann
      doc = Nokogiri::HTML(html_tv.body)

      #ZISKAVANIE NAZVVU TELEVIZNEJ STANICE
      station_name = doc.search('.head-line1a h1 strong').text
      #puts "Station: " + station_name

      #ULOZENIE STANICE DO DATABAZY
      Channel.find_or_create_by!(
          name: station_name
      )
      #program_day = doc.search('.head-days a .head-day-subtitle')[1].text.strip

      #PREHLADAVANIE TELEVIZNYCH STANIC
      doc.search('.tv-stations .tv-station').each do |station|


        program_day = station.search('.station-head h2 small').text
        #puts "Date je: " + program_day

        if program_day == 'Dnes'
          program_day = Date.today.strftime('%Y-%m-%d')
        elsif program_day == 'Zajtra'
               program_day = (Date.today + 1).strftime('%Y-%m-%d')
        elsif program_day == 'Včera'
          program_day = (Date.today - 1).strftime('%Y-%m-%d')
        end

        program_day_help = program_day
        #puts "Date 2 je: " + program_day


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

          array_time = prog_time_start.split(":")
          if array_time[0].to_i >= 0 && array_time[0].to_i < 5
            program_day = ((Date.parse program_day)+1).strftime('%Y-%m-%d')
            #puts "Datum je zmeneny: " + program_day
          end

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
          program_day = program_day_help
        end
      end
    end

  end

  def self.persist_and_retrieve_movie(movie_data)

    if movie_data["runtime"].to_s == ''
      movie_time = ""
    else
      if movie_data["runtime"].include?("x")
        movie_time = movie_data["runtime"].split("x")[1][0..-4]
      else
        movie_time = movie_data["runtime"][0..-4]
      end
    end

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
end