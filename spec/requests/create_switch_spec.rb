require 'spec_helper'

describe "CreateSwitch" do
  it "creates a switch" do
  	user = FactoryGirl.create(:user)

  	visit main_login_path
  	fill_in "name", 		:with => user.name
  	fill_in "password", 	:with => user.password
  	click_button "Login"

  	visit switch_new_path
  	fill_in "name", 		:with => "testswitch"
  	fill_in "address", 		:with => "localhost"
  	select "DefaultDriver",	:from => "switchType"
  	fill_in "description",	:with => "testswitch"
  	fill_in "loginname",	:with => "test"
  	fill_in "loginpassword",:with => "test"
  	fill_in "fwVersion",	:with => "v0.1"
  	click_button "Add"
  	switch = Switch.find_by_name("testswitch")
  	switch.address.should eq "localhost"
   end  
end
