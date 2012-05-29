class StorageController < ApplicationController
  def show
    @storages = Storages.all
  end

  def remove
    Storages.delete(params[:id])
    
    flash[:notice] = "Storage has been removed from database and can be rediscovered"
    
    redirect_to :controller => :storage, :action => :show
  end

end
