class Program < ActiveRecord::Base

  def self.parse_programs
    #http://tvprogramy.eu/?cas_od=00:00
    #http://tvprogramy.eu/?cas_od=aktual
    #http://tvprogramy.eu/tv-program-19-08-2014.html?cas_od=00:00&datum=tv-program-19-08-2014


    html_tv = Faraday.get 'http://tvprogramy.eu/tv-program-19-08-2014.html?cas_od=00:00&datum=tv-program-19-08-2014'
    doc = Nokogiri::HTML(html_tv.body)


    doc.search('table').each do |div|

      #puts div.search('#rating h2').text.to_i

      puts div.css('td').text

      #movie_origin = div.search('.origin').text.split(', ')

      #Channel.create!(
      #   name: div.search('h1').text.strip,
      #genre: div.search('.genre').text,
      #duration: movie_origin[2].split.first,
      #year: movie_origin[1].to_i,
      #description: div.search('.ct-related .content li')[0].text.strip,
      #rating: div.search('#rating h2').text.to_i,
      #time: div.search('a')[0].text,
      #)

    end

  end

  def self.extract_data
    html = Faraday.get 'http://tvprogramy.eu/tv-program-19-08-2014.html?cas_od=00:00&datum=tv-program-19-08-2014'
    Nokogiri::HTML(html.body).xpath("tr").collect do |row|
      puts row
      source      = row.at("td[2]").text.strip
    end
  end

end
