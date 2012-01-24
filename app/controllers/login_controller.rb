class LoginController < ApplicationController
  
  skip_before_filter :require_login, :only => [:create, :destroy]
  
  def create
    session[:current_user_id] = User.authenticate(params[:name], params[:password])
    if session[:current_user_id] then
      redirect_to root_url
    else
      flash[:error] = "Authentication failed"
      redirect_to :controller => :main, :action => :login
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to :controller => :main, :action => :login
  end

end
 