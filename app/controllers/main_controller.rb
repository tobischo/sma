class MainController < ApplicationController
  
  http_basic_authenticate_with :name => "sanmgmt", :password => "1", :except => :index
  
  def index
  end

end
