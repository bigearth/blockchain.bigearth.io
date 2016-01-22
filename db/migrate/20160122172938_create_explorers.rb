class CreateExplorers < ActiveRecord::Migration
  def change
    create_table :explorers do |t|

      t.timestamps null: false
    end
  end
end
