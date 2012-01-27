class CreateStoragees < ActiveRecord::Migration
  def change
    create_table :storagees do |t|
      t.string :name
      t.string :wwn

      t.timestamps
    end
  end
end
