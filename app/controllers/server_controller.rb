class ServerController < ApplicationController
  def show
    @servers = Servers.all
  end

  def remove
    Servers.delete(params[:id])
    
    flash[:notice] = "Server has been remnoved from database and can be rediscovered"
    
    redirect_to :controller => :server, :action => :show
    
  end

end
