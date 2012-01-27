class AddZoneToZoneMembers < ActiveRecord::Migration
  def change
    add_column :zone_members, :zone_id, :integer
  end
end
