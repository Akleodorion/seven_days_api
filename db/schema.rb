# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_05_19_072618) do
  create_table "challenges", force: :cascade do |t|
    t.string "description", null: false
    t.integer "status", default: 0, null: false
    t.integer "game_id"
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_challenges_on_game_id"
    t.index ["player_id"], name: "index_challenges_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "stopped_by"
    t.json "winners", default: []
    t.json "loosers", default: []
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "player_id"], name: "index_participants_on_game_id_and_player_id", unique: true
    t.index ["game_id"], name: "index_participants_on_game_id"
    t.index ["player_id"], name: "index_participants_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pledges", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "description", null: false
    t.integer "target_id"
    t.integer "player_id", null: false
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_pledges_on_game_id"
    t.index ["player_id"], name: "index_pledges_on_player_id"
  end

  add_foreign_key "challenges", "games"
  add_foreign_key "challenges", "players"
  add_foreign_key "participants", "games"
  add_foreign_key "participants", "players"
  add_foreign_key "pledges", "games"
  add_foreign_key "pledges", "players"
end
