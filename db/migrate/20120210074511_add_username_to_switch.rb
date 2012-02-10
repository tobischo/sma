class AddUsernameToSwitch < ActiveRecord::Migration
  def change
    add_column :switches, :username, :string
  end
end
