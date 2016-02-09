class CreatePlatformV1Chains < ActiveRecord::Migration
  def change
    create_table :platform_v1_chains do |t|
      t.text :pub_key
      t.boolean :droplet_created
      t.boolean :chef_node_bootstrapped
      t.string :ip_address

      t.timestamps null: false
    end
  end
end
