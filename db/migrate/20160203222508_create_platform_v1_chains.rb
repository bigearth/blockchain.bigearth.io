class CreatePlatformV1Chains < ActiveRecord::Migration
  def change
    create_table :platform_v1_chains do |t|
      t.text :pub_key

      t.timestamps null: false
    end
  end
end
