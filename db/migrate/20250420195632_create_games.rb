class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :status, default: 'created', null: false
      t.integer :stopped_by
      t.json :players, default: []
      t.datetime :end_date

      t.timestamps
    end
  end
end
