class SessionsController < ApplicationController
  before_action :redirect_logged_in, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by('lower(username) = ?', params[:session][:username].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully"
      redirect_to user
    else
      flash.now[:error] = "Sorry, your username or password is incorrect."
      render 'new', status: :unprocessable_entity
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully"
    redirect_to root_path
  end

  private

  def redirect_logged_in
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path
    end
  end
end
