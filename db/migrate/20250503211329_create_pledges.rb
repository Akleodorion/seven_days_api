class CreatePledges < ActiveRecord::Migration[7.0]
  def change
    create_table :pledges do |t|
      t.integer :status, default: 0
      t.string :description, null: false
      t.integer :target_id, null: true
      t.references :player, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true, null: true

      t.timestamps
    end
  end
end
