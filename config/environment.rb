# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Sanmgmtappl::Application.initialize!

ENV['RAILS_ENV'] ||= 'production'
