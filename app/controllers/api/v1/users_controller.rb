class Api::V1::UsersController < ApplicationController
  include ActionController::Cookies
  before_action :find_user, only: %i[show update destroy]
  before_action :authrize_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    if @user
      render json: @user 
    else
      render json: { error: 'Unautorized' }, status: 403
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user
    else
      render json: { error: 'Unable to create user', reasons: user.errors.full_messages }, status: 400
    end
  end

  def update
    if @user
      @user.update(user_params)
      render json: { message: 'User successfuly updated' }, status: 200
    else
      render json: { error: 'Unable to update user' }, status: 400
    end
  end

  def destroy
    if @user
      @user.destroy
      render json: { message: 'User successfuly deleted' }, status: 200
    else
      render json: { error: 'Unable to delete user' }, status: 400
    end
  end

  def login
    params.permit(:email, :password)
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      user.update_attribute(:token, create_user_token)
      cookies[:user_token] = user.token.to_s
      render json: { message: 'Logged in' }, status: 200
    else
      render json: { error: 'Wrong credentials' }, status: 400
    end
  end

  def logout
    cookies.delete :user_token
    render json: {message: 'Logged out, goodbye!'}, status: 200
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authrize_user
    logged_user ||= User.find_by_token(cookies[:user_token]) if cookies[:user_token]
    if @user&.id != logged_user&.id
      @user = nil
    end
  end

  def create_user_token
    SecureRandom.hex(10)
  end
end
