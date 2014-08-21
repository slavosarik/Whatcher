class Program < ActiveRecord::Base

  def self.parse_programs
    html_tv = Faraday.get 'http://tv-program.aktuality.sk/dnes/cely-den/'
    doc = Nokogiri::HTML(html_tv.body)

    stations = doc.search('.tv-stations')

    stations.search('.tv-station').each do |station|
      #name = station.search('.station-head h2 a').text
      #puts station

      prog = station.search('.programme')
      info = station.search('script')


      #puts prog[0]
      #puts info[1]

      prog.each_with_index do |item, index|
        puts item
        puts info[index+1]

        return
      end

    end
  end

  #puts stats[2]
  #puts stats[2].search('station-head')

  #doc.search('table').each do |div|

  #puts div.search('#rating h2').text.to_i

  # puts div.css('td').text

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

  #end
end
