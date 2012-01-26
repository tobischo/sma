class CreateSwitches < ActiveRecord::Migration
  def change
    create_table :switches do |t|
      t.string :type
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
