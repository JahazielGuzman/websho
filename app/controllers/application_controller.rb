class ApplicationController < ActionController::API

  def create_token(user)
    payload = {user_id: user.id}
    secret = ENV['token_secret']
    JWT.encode(payload, secret, "HS256")
  end

  def decode_token_return_user

    # get the token from the header
    auth_token = request.headers["Authorization"]
    # decode the token to get the user id
    decoded_token = JWT.decode(auth_token, ENV['token_secret'], true, { algorithm: 'HS256' })[0]
    user = User.find(decoded_token["user_id"])
  end

  def establish_session
    user = decode_token_return_user
    render json: {user: {id: user.id, name: user.name, username: user.username}}
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
      render json: {user: {id: user.id, name: user.name, username: user.username}, token: "Bearer #{token}"}
    else
      render json: {error: "user already exists"}
    end
  end

  def login
    username = params['username']

    user = User.find_by(username: username)
    error = ""
    if user
      is_authenticated = user.authenticate(params['password'])
      if is_authenticated
        token = create_token(user)
        render json: {user: {user_id: user.id, name: user.name, username: user.username}, token: "Bearer #{token}"}
      else
        render json: {error: "not authentic"}
      end
    else
      render json: {error: "user not found"}
    end
  end

end
