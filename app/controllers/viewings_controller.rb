class ViewingsController < ApplicationController

  def create

    user = decode_token_return_user
    movie = Movie.find(params["movie_id"])
    viewing = Viewing.create(user: user, movie: movie)
  end
end
