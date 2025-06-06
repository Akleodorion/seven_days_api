class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :status, default: 0, null: false
      t.integer :stopped_by, null: true
      t.json :players, default: [], null: false
      t.json :winnners, default: [], null: true
      t.datetime :end_date, null: true

      t.timestamps
    end
  end
end
