class ZoneController < ApplicationController
  def add
    z = Zones.create(:name => params[:name])
    
    if z then
      flash[:notice] = "New zone added"
      redirect_to :controller => :zone, :action => :show
    else
      flash[:error] = "Error adding zone"
      redirect_to :controller => :zone, :action => :new
    end
  end

  def new
    #only method definition with template
  end

  def remove
    Zones.destroy(params[:id])
    
    flash[:notice] = "Zone successfully removed"
    
    redirect_to :controller => :zone, :action => :show
  end

  def edit
    @zone = Zones.find(params[:id])
  end
  
  def update
    zone = Zones.find(params[:id])
    
    zone.name = params[:name]
    
    zone.save
    
    redirect_to :controller => :zone, :action => :show 
  end

  def show
    @zones = Zones.all
  end

end
