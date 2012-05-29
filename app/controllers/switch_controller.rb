class SwitchController < ApplicationController
  def add
    s = Switch.create(:name => params[:name],
                      :switchType => params[:switchType],
                      :address => params[:address],
                      :description => params[:description],
                      :username => params[:loginname],
                      :password => params[:loginpassword],
                      :fwVersion => params[:fwVersion])
                      
    
    if s then
      flash[:notice] = "New switch added"
      redirect_to :controller => :switch, :action => :show
    else
      flash[:error] = "Error adding switch"
      redirect_to :controller => :switch, :action => :new
    end
  end

  def remove
    Switch.delete(params[:id])
    
    flash[:notice] = "Switch has been remnoved"
    
    redirect_to :controller => :switch, :action => :show
  end
  
  def edit
    drivers = Dir[File.join(Rails.root,'lib','driver','*.rb')]
    @driverList = Array.new
    drivers.each{|content| @driverList << content.split('/').last.split('.').first}
    
    @switch = Switch.find(params[:id])
  end
  
  def update
    switch = Switch.find(params[:id])
    switch.name = params[:name];
    switch.switchType = params[:switchType];
    switch.address = params[:address];
    switch.description = params[:description];
    switch.username = params[:loginname];
    switch.password = params[:loginpassword];
    switch.fwVersion = params[:fwVersion];
    
    switch.save
    
    redirect_to :controller => :switch, :action => :show 
  end

  def new
    drivers = Dir[File.join(Rails.root,'lib','driver','*.rb')]
    @driverList = Array.new
    drivers.each{|content| @driverList << content.split('/').last.split('.').first}
  end

  def show
    @switches = Switch.all
  end

end
