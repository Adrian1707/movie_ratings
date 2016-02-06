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

set_date("20160207")
parse_cinema_data("http://www2.cineworld.co.uk/api/quickbook/cinemas?key=n7Dhu:mz&date=#{@date}")
store_names_in_hash
fetch_cinema("London - Wembley")
fetch_cinema_keys
parse_film_data("http://www2.cineworld.co.uk/api/quickbook/films?key=n7Dhu:mz&cinema=#{@key}&date=#{@date}")
store_films_in_hash
collect_film_names
print @films




current_date = Time.now.strftime("%Y%d%m")
