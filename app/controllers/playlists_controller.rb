class PlaylistsController < ApplicationController

  def newest_releases
    {cat: "Newest Releases", movies: Movie.order(release: :desc).limit(20)}
  end

  def movies_by_genre
    genres = Movie.pluck(:genre).uniq
    genre_playlists = []
    for g in genres
      genre_playlists << { cat: g, movies: Movie.where(genre: g) }
    end
    genre_playlists
  end

  def movies_always_show
     render json: [newest_releases(), *movies_by_genre()]
  end

  def recently_viewed
    user = decode_token_return_user
    render json: [{cat: "Recently Viewed" , movies: user.movies.order(created_at: :desc).limit(20)}]
  end

end
