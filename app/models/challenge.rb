class Challenge < ApplicationRecord
  belongs_to :game, optional: true
  belongs_to :player

  enum :status {
    created: 'Crée',
    ongoing: 'En cours',
    done: 'Terminé'
  }, _prefix: :status
end
