class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :challenges do |t|
      t.string :description, null: false
      t.string :status, null: false, default: 'Crée'
      t.references :game, null: true, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
