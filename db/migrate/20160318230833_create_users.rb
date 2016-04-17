class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :company
      t.string :location
      t.string :phone_number
      t.timestamps null: false
    end
  end
end
