require 'httparty'
require 'nokogiri'

class Burgerbot

  def run
    @page = nil
    @parsed_page = nil
    @string = nil
    @link = nil

    until appointment_available?
      puts '-' * 80
      puts 'Sleeping. . .'
      sleep 60
    end
  end

  def appointment_available?
    puts '-' * 80
    puts Time.now.utc.localtime("+02:00")
    @page = HTTParty.get('https://service.berlin.de/terminvereinbarung/termin/tag.php?id=&buergerID&buergername=&absagecode=&Datum=1472680800&anliegen%5B%5D=120686&dienstleister%5B%5D=122210&dienstleister%5B%5D=122217&dienstleister%5B%5D=122219&dienstleister%5B%5D=122227&dienstleister%5B%5D=122231&dienstleister%5B%5D=122243&dienstleister%5B%5D=122252&dienstleister%5B%5D=327338&dienstleister%5B%5D=122260&dienstleister%5B%5D=327340&dienstleister%5B%5D=122262&dienstleister%5B%5D=122254&dienstleister%5B%5D=122271&dienstleister%5B%5D=122273&dienstleister%5B%5D=122277&dienstleister%5B%5D=122280&dienstleister%5B%5D=122282&dienstleister%5B%5D=122284&dienstleister%5B%5D=122291&dienstleister%5B%5D=122285&dienstleister%5B%5D=122286&dienstleister%5B%5D=122296&dienstleister%5B%5D=150230&dienstleister%5B%5D=122301&dienstleister%5B%5D=122297&dienstleister%5B%5D=122294&dienstleister%5B%5D=122312&dienstleister%5B%5D=122314&dienstleister%5B%5D=122304&dienstleister%5B%5D=122311&dienstleister%5B%5D=122309&dienstleister%5B%5D=317869&dienstleister%5B%5D=324433&dienstleister%5B%5D=325341&dienstleister%5B%5D=324434&dienstleister%5B%5D=327352&dienstleister%5B%5D=324414&dienstleister%5B%5D=122283&dienstleister%5B%5D=327354&dienstleister%5B%5D=122276&dienstleister%5B%5D=327324&dienstleister%5B%5D=122274&dienstleister%5B%5D=327326&dienstleister%5B%5D=122267&dienstleister%5B%5D=327328&dienstleister%5B%5D=122246&dienstleister%5B%5D=122251&dienstleister%5B%5D=122257&dienstleister%5B%5D=122208&dienstleister%5B%5D=122226&herkunft=http://service.berlin.de/dienstleistung/120686/standort/122217/')
    @parsed_page = Nokogiri::HTML(@page)
    @string = @parsed_page.css('div.collapsible-body').to_s.split('calendar-table')[2]
    if @string && (@string.include?('Zeit gibt es keine Termine'))
      puts 'No appointments available at this time.' + @string.split('<br>')[0].split('>')[1]
      nil
    elsif @parsed_page.css('p').to_s.include?('Calm down')
      puts '429 Error. Will resume in 120 seconds.'
      print "\a"
      sleep 120
      nil
    else
      puts "DING DONG THERE'S AN APPOINTMENT!"
      (1..3).each do
        print "\a"
      end
      
    end
  end
end

Burgerbot.new.run

# ||parsed_page.css('td.buchbar u span').to_s == "<span>22</span>"
