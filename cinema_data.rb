require 'net/http'
require 'json'

def parse_data(url)
url = url
uri = URI(url)
response = Net::HTTP.get(uri)
@cinema_names = JSON.parse(response)
end

def store_names_in_hash
  @cinema_names_ids = []
  @cinema_names["cinemas"].each do |x|
    @cinema_names_ids << {x["id"] => x["name"]}
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
  @cinema_keys
end

parse_data("http://www2.cineworld.co.uk/api/quickbook/cinemas?key=n7Dhu:mz&date=20160211")
store_names_in_hash
fetch_cinema("Liverpool")
print fetch_cinema_keys


current_date = Time.now.strftime("%Y%d%m")
