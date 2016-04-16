class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.text :pub_key
      t.string :title
      t.string :flavor, default: 'bitcoin_core'
      t.boolean :node_created, default: false
      t.string :ipv4_address
      t.string :ipv6_address
      t.string :tier
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
