class CreateZoneMembers < ActiveRecord::Migration
  def change
    create_table :zone_members do |t|
      t.integer :refId
      t.string :elementType

      t.timestamps
    end
  end
end
