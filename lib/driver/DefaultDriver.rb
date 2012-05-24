require 'net/ssh'

class DefaultDriver
	def initialize(username, password, host, port)
		@session = Net::SSH.start(host, username, :port => port, :password => password)
	end

	def getservers
	  #test ssh command
	  #the parsing of the content is supposed to be done here and then return a list of servers
		@session.exec!("ruby dummyswitch.rb nsshow")
	end
	
	def getstorages
	  
	end
	
	def getaliases
	  
	end
	
	def getzones
	  
	end
	
	def setaliasses
	  
	end
	
	def setzones
	  
	end

	def finalize
		@session.close
	end
end
