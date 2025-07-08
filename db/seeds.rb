require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ActiveRecord::Base.transaction do
  Game.destroy_all
  Player.destroy_all

  players = %w[Player1 Player2].each.map do |player|
    Player.create(name: player)
  end

  challenges_data = []
  pledges_data = []

  players.each do |player|
    10.times do
      challenges_data << {
        description: Faker::Lorem.sentence(word_count: 6, supplemental: false, random_words_to_add: 4),
        player_id: player.id
      }

      pledges_data << {
        description: Faker::Lorem.sentence(word_count: 6, supplemental: false, random_words_to_add: 4),
        player_id: player.id
      }
    end
  end

  challenges = Challenge.insert_all(challenges_data)
  pledges = Pledge.insert_all(pledges_data)

  cross_pledges_data = []
  players.each do |target_player|
    other_player = players.find { |p| p.id != target_player.id }
    10.times do
      cross_pledges_data <<
        {
          description: Faker::Lorem.sentence(word_count: 6, supplemental: false, random_words_to_add: 4),
          player_id: other_player.id,
          target_id: target_player.id,
          status: [2, 3].sample,
        }
    end
  end

  Pledge.insert_all(cross_pledges_data)
end


def generate_description
  Faker::Lorem.sentence(word_count: 6, supplemental: false, random_words_to_add: 4)
end
