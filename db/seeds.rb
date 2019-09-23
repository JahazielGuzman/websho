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
image_path = "https://image.tmdb.org/t/p/original/"

# ============================
# Start Helper Methods
# ============================

def getActorDeets(actor)
  sleep(2)
  actor = Tmdb::Person.detail(actor["id"])
  if !actor["status_code"]
    actor
  end
end

def createActorAndCast(person, movie_id)
  image_path = "https://image.tmdb.org/t/p/original/"
  created_actor = Actor.create(
    name: person["name"],
    image: "#{image_path}#{person["profile_path"]}",
  )
  Cast.create(movie_id: movie_id, actor: created_actor)
end

# ============================
# End Helper Methods
# ============================


# ============================
# Start Creation of Movies
# ============================


# get movies in theatres, top rated and upcoming movies.
in_theatres = Tmdb::Movie.now_playing
top_rated = Tmdb::Movie.top_rated
upcoming = Tmdb::Movie.upcoming

# join them all together then make sure we don't have duplicated and get the deets for each
all_movies = in_theatres + top_rated + upcoming
all_movies = all_movies.uniq{|m| m.id}
all_movies = all_movies.map{|m| Tmdb::Movie.detail(m.id)}.select{|m| !m["status_code"]}

# randomly select movie id's to get details for and load them into all_movies array
movie_ids = (300000..470000).to_a.shuffle
for i in 1...1000 do
  random_movie = Tmdb::Movie::detail(movie_ids[i])
  if !random_movie["status_code"]
    movies << random_movie
  end
end
all_movies.concat(movies)

# again, make sure there aren't any duplicates
all_movies = all_movies.uniq{|m| m["id"]}
movie_ids = all_movies.map{|m| m["id"]}

# create a movie object for each movie in the array
all_movies.each do |m|
    Movie.create(
      title: m["original_title"],
      overview: m["overview"],
      release: m["release_date"],
      poster: "#{image_path}#{m["poster_path"]}",
      backdrop: "#{image_path}#{m["backdrop_path"]}",
      production: m["production_companies"].first,
      rating: m["vote_average"] / 2,
      popularity: m["popularity"]
    )
end

# ============================
# End Creation of Movies
# ============================


# ============================
# Start Creation of Actors
# ============================

mov_i = 1
movie_ids.each do |movie|

  cast = Tmdb::Movie.casts(movie)
  if cast != nil && cast != []

    cast[0...3].each do |actor|
      actors << [actor, mov_i]
    end
  end
  mov_i += 1
end

actorsq = actors.uniq{|a| a[0]["name"]}
actors.each{|a| createActorAndCast(a[0], a[1])}
binding.pry


# ============================
# End Creation of Actors
# ============================


# bm_deets = Tmdb::Movie.details(bm.id)
# bm_cast = Tmdb::Movie.casts(bm.id)
# bm_trailers = Tmdb::Movie.trailers(bm.id)
