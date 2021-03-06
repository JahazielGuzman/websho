# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'themoviedb'
require 'pry'

# initiate API with key
Tmdb::Api.key(ENV['tmdb_api_key'])
movies = []
actors = []
all_movies = []
backdrop_path = "https://image.tmdb.org/t/p/original"
poster_path = "https://image.tmdb.org/t/p/w500"

# ============================
# Start Helper Methods
# ============================

def getActorDeets(actor)
  sleep(5)
  actor = Tmdb::Person.detail(actor["id"])
  if !actor["status_code"]
    actor
  end
end

def createActorAndCast(person, movie_id)
  image_path = "https://image.tmdb.org/t/p/original"
  created_actor = Actor.create(
    name: person["name"],
    image: "#{image_path}#{person["profile_path"]}"
  )
  Cast.create(movie_id: movie_id, actor: created_actor)
end

# ============================
# End Helper Methods
# ============================


# ============================
# Start Creation of Movies
# ============================

# join them all together then make sure we don't have duplicated and get the deets for each
# all_movies = all_movies.uniq{|m| m.id}

sleep(30)
# all_movies = all_movies.map{|m| Tmdb::Movie.detail(m.id)}.select{|m| !m["status_code"]}

# randomly select movie id's to get details for and load them into all_movies array
# movie_ids = (300000..470000).to_a.shuffle
# for i in 1...1000 do
#   random_movie = Tmdb::Movie::detail(movie_ids[i])
#   if !random_movie["status_code"]
#     movies << random_movie
#   end
# end
# all_movies.concat(movies)
sleep(30)
genres = Tmdb::Genre.list["genres"]

sleep(30)

for g in genres do
  genre_detail = Tmdb::Genre.detail(g["id"])
  max_pages = 7
  num_pages = genre_detail.total_pages < max_pages ? genre_detail.total_pages : max_pages
  results = genre_detail.results
  results = results.each{ |r| r["genres"] = [{"name" => genre_detail.name}] }
  all_movies.concat(results)
  for i in 2...num_pages do
    sleep(1)
    results = genre_detail.get_page(i).results
    results = results.each{ |r| r["genres"] = [{"name" => genre_detail.name}] }
    all_movies.concat(results)
  end
end

# again, make sure there aren't any duplicates
all_movies = all_movies.uniq{|m| m["id"]}
movie_ids = all_movies.map{|m| m["id"]}

sleep(30)
# create a movie object for each movie in the array
all_movies.each do |m|
  # trailer = Tmdb::Movie.trailers(m["id"])
  #
  # if trailer["youtube"] != nil && trailer["youtube"] != []
  #   trailer = trailer["youtube"][0]["source"]
  # else
  #   trailer = "b9434BoGkNQ"
  # end
  if m["backdrop_path"] != nil && m["backdrop_path"] != "" && m["release_date"] != nil && m["poster_path"] != nil
    Movie.create(
      title: m["original_title"],
      overview: m["overview"],
      release: m["release_date"],
      poster: "#{poster_path}#{m['poster_path']}",
      backdrop: "#{backdrop_path}#{m["backdrop_path"]}",
      rating: m["vote_average"] / 2,
      popularity: m["popularity"],
      original_id: m["id"],
      genre: m["genres"][0]["name"]
    )
  end
end

# ============================
# End Creation of Movies
# ============================