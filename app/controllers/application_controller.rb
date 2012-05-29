class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  
  private
    
    def logged_in?
      !!current_user
    end
  
    def require_login
      unless logged_in?
        flash[:error] = "The requested site requires login."
        redirect_to root_url
      end
    end
    
    def current_user
      @_current_user ||= session[:current_user] && User.find(session[:current_user])
    end
end
