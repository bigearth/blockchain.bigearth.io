class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.text :pub_key
      t.string :title
      t.string :flavor, default: 'bitcoin_core'
      t.boolean :droplet_created, default: false
      t.string :ip_address
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
