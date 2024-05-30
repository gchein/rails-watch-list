# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
puts 'Cleaning list database...'
List.destroy_all
puts 'Done!'

puts 'Cleaning bookmark database'
if Bookmark.all.empty?
  puts 'No bookmarks found'
else
  Bookmark.destroy_all
end
puts 'Done!'

puts 'Cleaning movie database'
Movie.destroy_all
puts 'Done!'

puts 'Creating movies'
# the Le Wagon copy of the API
url = 'https://tmdb.lewagon.com/movie/top_rated'
response = JSON.parse(URI.open(url).read)

response['results'].each do |movie_hash|
  title = movie_hash['title']
  puts "Seeding #{title}"
  overview = movie_hash['overview']
  poster_url = "https://image.tmdb.org/t/p/w500" + movie_hash['poster_path']
  rating = movie_hash['vote_average']

  Movie.create! title:, overview:, poster_url:, rating:
end
puts 'Done!'

puts 'Creating lists'
list_one = List.new(name: 'Listinha Bolada')
list_two = List.new(name: 'La Listiña')

[list_one, list_two].each do |list|
  puts "Created list '#{list.name}'" if list.save!
end
puts 'Done!'


puts 'Creating bookmarks'
bk_one = Bookmark.new(list: list_one, movie: Movie.all[1], comment: 'Solid Movie')
bk_two = Bookmark.new(list: list_two, movie: Movie.all[3], comment: 'Meh, not so great')
bk_three = Bookmark.new(list: list_two, movie: Movie.all[7], comment: 'BEST MOVIE EVERRR')
bk_four = Bookmark.new(list: list_two, movie: Movie.all[9], comment: '10/10 would watch again')

[bk_one, bk_two, bk_three, bk_four].each do |bk|
  puts "Created bookmark on list '#{bk.list.name}' for '#{bk.movie.title}'" if bk.save!
end
puts 'Done!'
