class LoginController < ApplicationController
  
  skip_before_filter :require_login, :only => [:create, :destroy]
  
  def create
    session[:current_user_id] = 1
    redirect_to root_url
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_url
  end

end
