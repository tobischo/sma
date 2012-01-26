class RemoveTypeFromSwitches < ActiveRecord::Migration
  def up
    remove_column :switches, :type
  end

  def down
    add_column :switches, :type, :string
  end
end
