class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end

    add_index :participants, [:game_id, :player_id], unique: true
  end
end
