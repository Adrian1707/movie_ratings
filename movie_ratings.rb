#!/usr/bin/env ruby
require_relative 'cinema_data'

set_date("20160208")
parse_cinema_data("http://www2.cineworld.co.uk/api/quickbook/cinemas?key=n7Dhu:mz&date=#{@date}")
store_names_in_hash
puts "\nWhat cinema do you want to visit? e.g. London - Wembley, London - Haymarket, Chesterfield.\n"
cinema = gets.chomp
fetch_cinema(cinema)
fetch_cinema_keys
parse_film_data("http://www2.cineworld.co.uk/api/quickbook/films?key=n7Dhu:mz&cinema=#{@key}&date=#{@date}")
store_films_in_hash
collect_film_names
format_film_names
get_film_ratings
store_rating_and_film_in_hash
remove_blanks
present_in_lines
