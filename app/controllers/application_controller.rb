class ApplicationController < ActionController::API

  def create_token(user)
    payload = {user_id: user.id}
    secret = ENV['token_secret']
    JWT.encode(payload, secret, "HS256")
  end

  def signup
    # get the 3 data points to create a user
    username = params['username']
    name = params['name']
    pass = params['password']

    # check if the username already exists
    user = User.find_by(username: username)

    # if the user doesn't exist then create the user, otherwise send an error that user exists
    if !user
      user = User.create(username: username, name: name, password: pass)
      # generate the JWT token
      token = create_token(user)
      # send it back to the user
      render json: {name: user.name, username: user.username, token: "Bearer #{token}"}
    else
      render json: {error: "user already exists"}
    end
  end

  def login
    username = params['username']

    user = User.find_by(username: username)

    if user
      is_authenticated = user.authenticate(params['password'])
      if is_authenticated
        token = create_token(user)
        render json: {name: user.name, username: user.username, token: "Bearer #{token}"}
      end
    else
      render json: {error: "no authenticated"}
    end
  end

end
