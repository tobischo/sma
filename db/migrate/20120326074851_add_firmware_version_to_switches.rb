class AddFirmwareVersionToSwitches < ActiveRecord::Migration
  def change
    add_column :switches, :fwVersion, :string
  end
end
