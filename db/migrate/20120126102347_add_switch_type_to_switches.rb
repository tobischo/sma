class AddSwitchTypeToSwitches < ActiveRecord::Migration
  def change
    add_column :switches, :switchType, :string
  end
end
