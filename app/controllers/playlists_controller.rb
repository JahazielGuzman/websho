class PlaylistsController < ApplicationController
  def recently_viewed

  end

  def newest_releases
    render json: Movie.order(release: :desc).limit(20)
  end
end
