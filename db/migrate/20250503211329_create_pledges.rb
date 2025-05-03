class CreatePledges < ActiveRecord::Migration[7.0]
  def change
    create_table :pledges do |t|
      t.string :status, default: 'Crée'
      t.string :description, null: false
      t.references :player, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true, null: true
      t.integer :target_id, null: false

      t.timestamps
    end
  end
end
