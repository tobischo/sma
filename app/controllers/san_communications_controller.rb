Dir[File.join(RAILS_ROOT,'lib','driver')].each {|file| require file }

class SanCommunicationsController < ApplicationController
  
  def call
    switch = Switch.find(params[:id])
    driver = Object.const_get(switch.switchType)
    host = switch.address.split(':')[0]
    port = switch.address.split(':')[1]
    driver.new(switch.username,switch.password,host,port)
    
    s.send(param[:method])
    
  end
  
end
