class MainController < ApplicationController
  
  skip_before_filter :require_login, :only => [:login]

  def index
  end
  
  def login
    render :layout => 'login'
  end

end