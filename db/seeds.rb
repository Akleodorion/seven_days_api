require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Game.destroy_all
Player.destroy_all

%w[Player1 Player2].each do |player|
  player = Player.create(name: player)
  3.times do |n|
    Challenge.create(description: Faker::Lorem.sentence(word_count: 6, supplemental: false, random_words_to_add: 4), player:)
    Pledge.create(description: Faker::Lorem.sentence(word_count: 6, supplemental: false, random_words_to_add: 4), player:)
  end
end
