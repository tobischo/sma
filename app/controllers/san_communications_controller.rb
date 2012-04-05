Dir[File.join(Rails.root,'lib','driver','*.rb')].each {|file| require file}

class SanCommunicationsController < ApplicationController

  def call

    switch = Switch.find(params[:id])
    driver = Object.const_get(switch.switchType)
    host = switch.address.split(':')[0]
    port = switch.address.split(':')[1]

    if port.nil? then
      port = 22
    end

    switchInstance = driver.new(switch.username,switch.password,host,port)

    if switchInstance.respond_to? params[:method] then  
      @result = switchInstance.send(params[:method])
    else
      @result = "No such method #{params[:method]}"
    end
    
  end
  
end
