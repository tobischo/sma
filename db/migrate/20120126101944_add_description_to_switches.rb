class AddDescriptionToSwitches < ActiveRecord::Migration
  def change
    add_column :switches, :description, :string
  end
end
