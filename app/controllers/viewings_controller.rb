class ViewingsController < ApplicationController

  def create

    user = decode_token_return_user
    movie = Movie.find(params["movie_id"])
    past_viewing = Viewing.find_by(user: user, movie: movie.id)
    if past_viewing
      past_viewing.destroy
    end
    viewing = Viewing.create(user: user, movie: movie)
  end
end
