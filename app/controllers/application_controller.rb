class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  
  private
  
    def require_login
      unless logged_in?
        flash[:error] = "Login required to access this section"
        redirect_to new_login_url
      end
    end
    
    def logged_hin?
      !!current_user
    end
    
    def current_user
      @_current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
    end

end
