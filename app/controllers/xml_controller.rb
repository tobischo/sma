class XmlController < ApplicationController
  def generate
    
    @server = Hash.new
    @server['1'] = "ServerA"
    @server['2'] = "ServerB"
    @server['3'] = "ServerC"
    
    @storage = Hash.new
    @storage['1'] = "StorageA"
    @storage['2'] = "StorageB"
    
    @switch = Hash.new
    @switch['1'] = "SwitchA"
    @switch['2'] = "SwitchB"
    
    @connection = Array.new
    @connection = [{:from => "1", :over => "1", :to => "2"}, 
                   {:from => "2", :over => "2", :to => "2"}]

    render :layout => false
  end
  
  def update
    render :nothing => true

    model = params[:model]
    
    puts model
  end

end
