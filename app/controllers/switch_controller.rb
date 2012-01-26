class SwitchController < ApplicationController
  def add
    s = Switch.create(:name => params[:name], :switchType => params[:switchType], :address => params[:address], :description => params[:description])
    
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

  def new
  end

  def show
    @switches = Switch.all
  end

end
