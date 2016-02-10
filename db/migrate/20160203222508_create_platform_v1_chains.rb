class CreatePlatformV1Chains < ActiveRecord::Migration
  def change
    create_table :platform_v1_chains do |t|
      t.text :pub_key
      t.string :blockchain_flavor, default: 'bitcoin_core'
      t.boolean :droplet_created, default: false
      t.string :ip_address

      t.timestamps null: false
    end
  end
end
