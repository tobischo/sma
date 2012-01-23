class MainController < ApplicationController
  
  skip_before_filter :require_login, :only => [:login]
  session :on

  def index
  end
  
  def login
  end

end
