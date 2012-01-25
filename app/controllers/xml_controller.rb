class XmlController < ApplicationController
  def generate
    
    @server = Hash.new
    @server['1'] = "ServerA"
    @server['2'] = "ServerB"
    @server['3'] = "ServerC"
    
    @storage = Hash.new
    @storage['1'] = "StorageA"
    @storage['2'] = "StorageB"
    
    @connection = Array.new
    @connection = [{:from => "1", :to => "2"}, {:from => "2", :to => "2"}]

    render :layout => false
  end

end
