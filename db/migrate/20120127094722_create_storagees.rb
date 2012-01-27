class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :name
      t.string :wwn

      t.timestamps
    end
  end
end
