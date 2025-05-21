class Player < ApplicationRecord

  has_many :games, through: :participant
  has_many :challenges, dependent: :destroy
  has_many :pledges, dependent: :destroy

  validates :name, presence: true
end
