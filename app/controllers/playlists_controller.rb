class PlaylistsController < ApplicationController


  ##########################
  # start helper functions
  ##########################

  # is b within 3 years of a? If so return -1 otherwise 0
  def within_three_years?(a, b)
    date_diff = a.split('-')[0].to_i - b.split('-')[0].to_i
    if date_diff > -3 && date_diff < 3
      -1
    else
      0
    end
  end

  ##########################
  # end helper functions
  ##########################


  def newest_releases

    {cat: "Newest Releases", movies: Movie.order(release: :desc).limit(40)}
  end

  def movies_by_genre
    genres = Movie.pluck(:genre).uniq
    genre_playlists = []
    for g in genres
      genre_playlists << { cat: g, movies: Movie.where(genre: g).limit(40) }
    end
    genre_playlists
  end

  def movies_by_past
    # get the movie that were recently viewed
    recent = recently_viewed()[:movies]

    # we will store an array of recommended movies by recently viewed movie
    in_genre = []

    # set how many times we will iterate, how many movies to recommend by
    if recent.length == 0
      num_movies = 0
    elsif recent.length < 5
      num_movies = recent.length
    else
      num_movies = 5
    end

    # for each movie, get the movies with the same genre
    for i in 0...num_movies # for recommended movie R[i]
      word_match = []
      word_not_match = []

      in_genre << {cat: "Because you watched: #{recent[i].title}", movies: Movie.where(genre: recent[i].genre).limit(40).to_a.filter{|a| a.id != recent[i].id}}
      # split the title into words
      title_words = recent[i].title.split(' ')
      # track if any word is in other title
      titles_match = false

      # go through each movie in the genre and see if it has a word in common with the title
      for movie in in_genre[i][:movies] # for movie m1, m2, m3 ... in G[i]

        for word in title_words
          if movie.title.include? word
            titles_match = true
            break
          end
        end

        if titles_match
          word_match << movie
        else
          word_not_match << movie
        end

        titles_match = false
      end

      # now with the ones that don't match, we want to bring ones + or - 3 years to the top
      word_not_match = word_not_match.sort{
        |m|
        within_three_years?(recent[i].release, m.release)
      }

      in_genre[i][:movies] = word_match + word_not_match

    end
    in_genre
  end


  def movies_always_show

     render json: [newest_releases(), * movies_by_genre()]
  end

  def recently_viewed
    user = decode_token_return_user
    {cat: "Recently Viewed" , movies: user.viewings.order(created_at: :desc).limit(20).map{|v| v.movie}}
  end

  def user_custom_movies
    recent = recently_viewed()
    if recent[:movies].length > 0
      render json: [recent, * movies_by_past()]
    else
      render json: movies_by_past()
    end
  end

end
