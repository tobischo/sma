class XmlController < ApplicationController
  def generate
    
    @server = Hash.new
    Servers.all.each do |server|
      @server[server.id] = server.name
    end
    #@server['1'] = "ServerA"
    #@server['2'] = "ServerB"
    #@server['3'] = "ServerC"
    
    @storage = Hash.new
    Storages.all.each do |storage|
      @storage[storage.id] = storage.name 
    end
    #@storage['1'] = "StorageA"
    #@storage['2'] = "StorageB"
    
    @switch = Hash.new
    Switch.all.each do |switch|
      @switch[switch.id] = switch.name
    end
    #@switch['1'] = "SwitchA"
    #@switch['2'] = "SwitchB"
    
    @connection = Array.new
    Zones.all.each do |zone|
      tmpCon = Hash.new
      zone.zone_members.each do |zm|
        if zm.elementType == "Server" then
          tmpCon[:from] = zm.refId
        elsif zm.elementType == "Switch" then
          tmpCon[:over] = zm.refId
        elsif zm.elementType == "Storage" then
          tmpCon[:to] = zm.refId
        end
      end
      
      tmpCon[:name] = zone.name
      
      @connection << tmpCon
      
    end
    #@connection = [{:from => "1", :over => "1", :to => "2"}, 
    #               {:from => "2", :over => "2", :to => "2"}]

    render :layout => false
  end
  
  def update
    render :nothing => true

    model = params[:model]

    if !model[:connectionList].nil? then #check if connectionlist is empty -> prevent error
      if model[:connectionList][:connection].class == Array then #check if there are multiple connections
        model[:connectionList][:connection].each do |m| #if multiple connections: loop through them
          check_conn(m)
        end
      else
        check_conn(model[:connectionList][:connection])
      end
      
      #puts model[:connectionList][:connection].class
    end
    
    if !model[:deletedList].nil? then #check if cdeletedlist is empty -> prevent error
      if model[:deletedList][:connection].class == Array then #check if there are multiple connections
        model[:deletedList][:connection].each do |m| #if multiple connections: loop through them
          delete_conn(m)
        end
      else
        delete_conn(model[:deletedList][:connection])
      end
    end

  end

end

private

  def check_conn(m) #this method checks if the via xml transmitted connection already exists: if not it is created
    exists = false
          
    Zones.all.each do |zone|
      server = zone.zone_members.where(:elementType => "Server", :refId => m[:from]).first
      switch = zone.zone_members.where(:elementType => "Switch", :refId => m[:over]).first
      storage = zone.zone_members.where(:elementType => "Storage", :refId => m[:to]).first
          
      if server && storage && switch then
        exists = true
      end
    end
        
    if !exists then
      token = "Generic " + (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
          
      while !Zones.where(:name => token).empty? do
        token = "Generic " + (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
      end
            
      z = Zones.create(:name => token)
      z.zone_members << ZoneMembers.create(:refId => m[:from], :elementType => "Server")
      z.zone_members << ZoneMembers.create(:refId => m[:over], :elementType => "Switch")
      z.zone_members << ZoneMembers.create(:refId => m[:to], :elementType => "Storage")
      z.save
    end
  end
  
  def delete_conn(m) #this method removes zones that fit the connection
    Zones.all.each do |zone|
      server = zone.zone_members.where(:elementType => "Server", :refId => m[:from]).first
      switch = zone.zone_members.where(:elementType => "Switch", :refId => m[:over]).first
      storage = zone.zone_members.where(:elementType => "Storage", :refId => m[:to]).first
      
      if server && storage && switch then
        server.delete
        storage.delete
        switch.delete
        
        zone.delete
      end
      
    end
  end
