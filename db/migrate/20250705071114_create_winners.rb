class CreateWinners < ActiveRecord::Migration[7.0]
  def up
    create_table :winners do |t|
      t.references :player, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table(:winners)
  end
end
