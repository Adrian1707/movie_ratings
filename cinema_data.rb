require 'net/http'
require 'json'

def get_uri(url)
  @url = url
  @uri = URI(url)
  @response = Net::HTTP.get(@uri)
end

def parse_cinema_data(url)
  get_uri(url)
  @cinema_names = JSON.parse(@response)
end

def parse_film_data(url)
  get_uri(url)
  @film_names = JSON.parse(@response)
end

def store_names_in_hash
  @cinema_names_ids = []
  @cinema_names["cinemas"].each do |x|
    @cinema_names_ids << {x["id"] => x["name"]}
  end
end

def store_films_in_hash
  @films = []
  @film_names_ids = []
  @film_names["films"].each do |x|
    @film_names_ids << {x["edi"] => x["title"]}
  end
end

def collect_film_names
  @film_names_ids.each do |x|
    @films << x.values
  end
  @films
end

def fetch_cinema(name)
  @results = []
  @cinema_names_ids.each do |cinema|
    if cinema.values.join('').include? name
      @results << cinema
    end
  end
  @results
end

def fetch_cinema_keys
  @cinema_keys = []
  @results.each do |x|
    @cinema_keys << x.keys.join('').to_i
  end
  @key = @cinema_keys.join('')
end

def set_date(date)
  @date = date
end

def parse_film_ratings(url)
  get_uri(url)
  @film_details = JSON.parse(@response)
end

def fetch_film_rating(film)
  film["imdbRating"]
end

def format_film_names
  @films.map! do |film|
    if film.join('').split(' - ').last.split(' ').join(' ').match(" ")
        film.join('').split(' - ').last.split(' ').join(' ').gsub!(/\s/,'+')
    else
      film.join('').split(' - ').last.split(' ').join(' ')
    end
  end
end


def get_film_ratings
  @ratings = []
  @films.each do |film|
     parse_film_ratings("http://www.omdbapi.com/?t=#{film}&y=&plot=short&r=json")
     @ratings << fetch_film_rating(@film_details)
  end
  @ratings
end

def store_rating_and_film_in_hash
  @film_and_ratings = []
    @films.each_with_index do |film,i|
      @film_and_ratings << {"#{@ratings[i]}" => "#{film.gsub!(/\+/,' ')}"}
  end
  @film_and_ratings.uniq!
end

def rank_by_rating
  @film_and_ratings.sort_by{ |hash| hash['count'] }.reverse
end

def remove_blanks
  @film_and_ratings.each do |film|
    if film.values.any?{|v| v.nil? || v.length == 0} || film.keys.any?{|v| v.nil? || v.length == 0}
      @film_and_ratings.delete(film)
    end
  end
end

def present_in_lines
  @film_and_ratings.each do |film|
    puts "#{film.values.join("")}: Rating: #{film.keys.join('').to_f}\n"
  end
end

# set_date("20160208")
# parse_cinema_data("http://www2.cineworld.co.uk/api/quickbook/cinemas?key=n7Dhu:mz&date=#{@date}")
# store_names_in_hash
# fetch_cinema("Milton Keynes")
# fetch_cinema_keys
# parse_film_data("http://www2.cineworld.co.uk/api/quickbook/films?key=n7Dhu:mz&cinema=#{@key}&date=#{@date}")
# store_films_in_hash
# collect_film_names
# format_film_names
# get_film_ratings
# store_rating_and_film_in_hash
# remove_blanks
# present_in_lines




current_date = Time.now.strftime("%Y%d%m")
