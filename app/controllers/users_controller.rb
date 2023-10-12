class UsersController < ApplicationController
  before_action :find_user, except: %i[index new create]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You have succesfully registered #{@user.username}. Welcome!"
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

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

end
