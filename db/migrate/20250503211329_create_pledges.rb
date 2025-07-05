class CreatePledges < ActiveRecord::Migration[7.0]
  def change
    create_table :pledges do |t|
      t.integer :status, default: 0
      t.string :description, null: false
      t.references :target, foreign_key: { to_table: :players }
      t.references :player, null: false, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
