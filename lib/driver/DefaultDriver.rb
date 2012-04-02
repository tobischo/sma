require 'net/ssh'

class DefaultDriver
	def initialize(username, password, host, port)
		@session = Net::SSH.start(host, username, :port => port, :password => password)
	end

	def nsshow
		@session.exec!("ruby dummyswitch.rb nsshow")
	end

	def finalize
		@session.close
	end
end
