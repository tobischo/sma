class ZoneController < ApplicationController
  def add
  end

  def new
  end

  def remove
    Zones.destroy(param[:id])
    
    flash[:notice] = "Zone successfully removed"
    
    redirect_to :controller => :zone, :action => :show
  end

  def edit
  end

  def show
  end

end
