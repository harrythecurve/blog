class UsersController < ApplicationController
  before_action :redirect_logged_in, only: %i[new create]
  before_action :find_user, except: %i[index new create]
  before_action :require_user, only: %i[index edit update]
  before_action :authorise_user, only: %i[edit update]
  before_action :require_admin, only: %i[index destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You have succesfully registered #{@user.username}. Welcome!"
      session[:user_id] = @user.id
      redirect_to articles_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = "You have succesfully updated your details #{@user.username}!"
      redirect_to edit_user_path(@user.id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    if @user.destroy
      session[:user_id] = nil if current_user == @user
      flash[:notice] = "Account successfully deleted"
      redirect_to root_path
    else
      flash[:error] = "There was an issue with deleting the account"
      redirect_to user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def redirect_logged_in
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path
    end
  end

  def authorise_user
    unless current_user == @user || current_user&.admin?
      flash[:error] = "You can only edit or delete your own profile"
      redirect_to @user
    end
  end
end
