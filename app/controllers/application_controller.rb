class ApplicationController < ActionController::Base
  layout 'application'

  helper_method :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :logged_in?
  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end

  def require_admin(path = root_path)
    unless current_user&.admin?
      flash[:error] = "You are unauthorized to access this page"
      redirect_to path
    end
  end
end
