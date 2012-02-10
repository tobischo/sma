class AddPasswordToSwitch < ActiveRecord::Migration
  def change
    add_column :switches, :password, :String
  end
end
