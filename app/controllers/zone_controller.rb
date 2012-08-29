class ZoneController < ApplicationController
  
  def create
    #check if the parameter are set -> to prevent errors later on
    if params[:server].nil? then
      flash[:error] = "Server not set"
      redirect_to :controller => :zone, :action => :new
      return
    end
    if params[:switch].nil? then
      flash[:error] = "Switch not set"
      redirect_to :controller => :zone, :action => :new
      return
    end
    if params[:storage].nil? then
      flash[:error] = "Storage not set"
      redirect_to :controller => :zone, :action => :new
      return
    end
    if params[:name].empty? then
      flash[:error] = "Name can not be empty"
      redirect_to :controller => :zone, :action => :new
      return
    end
    
    #check if the zone already exists for those settings (under a different name)
    Zones.all.each do |zone|
      server = zone.zone_members.where(:elementType => "Server", :refId => params[:server]).first
      switch = zone.zone_members.where(:elementType => "Switch", :refId => params[:switch]).first
      storage = zone.zone_members.where(:elementType => "Storage", :refId => params[:storage]).first
      
      #if a zone exists -> no new one can be added
      if server && storage && switch then
        flash[:error] = "Zone for these settings already exists"
        redirect_to :controller => :zone, :action => :show
        return
      end
    end
    
    #in case the zone does not exist: create a new one
    z = Zones.create(:name => params[:name])
    
    if z then
      flash[:notice] = "New zone added"
      redirect_to :controller => :zone, :action => :show
    else
      flash[:error] = "Error adding zone"
      redirect_to :controller => :zone, :action => :new
      return
    end
    
    server = ZoneMembers.create({:refId => params[:server], :elementType => "Server"})
    switch = ZoneMembers.create(:refId => params[:switch], :elementType => "Switch")
    storage = ZoneMembers.create(:refId => params[:storage], :elementType => "Storage")
    z.zone_members << server
    z.zone_members << switch
    z.zone_members << storage
    z.save
    
  end

  def new
    #create hashmaps for the different types can be properly handled by 'options_for_select' in the view
    @serverList = Hash.new(0)
    Servers.all.each do |server|
      @serverList[server.name] = server.id
    end
    
    @storageList = Hash.new(0)
    Storages.all.each do |storage|
      @storageList[storage.name] = storage.id
    end
 
    
    @switchList = Hash.new(0)
    Switch.all.each do |switch|
      @switchList[switch.name] = switch.id
    end
  end

  def remove
    zone = Zones.find(params[:id])
    
    zone.zone_members.each do |zm|
      zm.destroy
    end
    
    zone.destroy#Zones.destroy(params[:id])
    
    flash[:notice] = "Zone successfully removed"
    
    redirect_to :controller => :zone, :action => :show
  end

  def edit
    @zone = Zones.find(params[:id])
    @server
    @switch
    @storage
    
    #create variables for the default/selected elements in the list
    @zone.zone_members.each do |zm|
      if zm.elementType == "Server" then
        @server = zm.refId
      elsif zm.elementType == "Switch" then
        @switch = zm.refId
      elsif zm.elementType == "Storage" then
        @storage = zm.refId
      end
    end
    
    #create hashmaps for the different types can be properly handled by 'options_for_select' in the view
    @serverList = Hash.new(0)
    Servers.all.each do |server|
      @serverList[server.name] = server.id
    end
    
    @storageList = Hash.new(0)
    Storages.all.each do |storage|
      @storageList[storage.name] = storage.id
    end
    
    @switchList = Hash.new(0)
    Switch.all.each do |switch|
      @switchList[switch.name] = switch.id
    end
    
  end
  
  def update
    #set the new values
    zone = Zones.find(params[:id])
    
    zone.name = params[:name]
    
    zone.save
    
    #check if such a zone already exists
    Zones.all.each do |zone|
      server = zone.zone_members.where(:elementType => "Server", :refId => params[:server]).first
      switch = zone.zone_members.where(:elementType => "Switch", :refId => params[:switch]).first
      storage = zone.zone_members.where(:elementType => "Storage", :refId => params[:storage]).first
      
      #if a zone exists -> no new one can be added
      if server && storage && switch then
        flash[:error] = "Zone for these settings already exists"
        redirect_to :controller => :zone, :action => :show
        return
      end
    end
    
    zone.zone_members.each do |zm|
      if zm.elementType == "Server" then
        zm.refId = params[:server]
      elsif zm.elementType == "Switch" then
        zm.refId = params[:switch]
      elsif zm.elementType == "Storage" then
        zm.refId = params[:storage]
      end
      zm.save
    end
    
    redirect_to :controller => :zone, :action => :show 
  end

  def show
    @zones = Zones.all
  end

end
