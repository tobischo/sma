class AddZoneToZoneMembers < ActiveRecord::Migration
  def change
    add_column :zone_members, :zones_id, :integer
  end
end
