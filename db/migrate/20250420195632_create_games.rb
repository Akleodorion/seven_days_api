class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :status, default: 0, null: false
      t.references :stopped_by, foreign_key: { to_table: :players }
      t.datetime :end_date, null: true

      t.timestamps
    end
  end
end
