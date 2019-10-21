class MoviesController < ApplicationController

  def search_movies
    query = params["search_query"]
    if (query.length <= 3)
      regexified = ".*#{query[0]}#{query[1..].split('').join('?')}?"
    else
      regexified = ".*#{query[0..1]}#{query[3..].split('').join('?')}?"
    end
    matches = Movie.where("title ~* ?", regexified).limit(40)
    render json: {cat: "Matched #{query}:", movies: matches}
  end

end
