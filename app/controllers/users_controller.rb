class UsersController < ApplicationController
  before_action :authorized, only: [ :show ]

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { message: "Logged in successfully", token: token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def current
    render json: { user: current_user }
  end

  def show
    render json: { user: current_user }
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
