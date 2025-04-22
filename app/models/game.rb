class Game < ApplicationRecord

  validate :ony_one_ongoing_game, if: -> { status == 'ongoing' }

  enum :status {
    created: 'Crée'
    ongoing: 'En cours'
    over: 'Terminé'
    decided: 'Décidé'
    archived: 'Archivé'
  }, _prefix: :status

  def self.active_game
    find_by(status: :ongoing)
  end

  def next_step(id: nil)
    case status
    when :created
      from_created_to_ongoing
    when :ongoing
      from_ongoing_to_over(id)
    when :over
      from_over_to_decided
    when :decided
      from_decided_to_archived
    else
      self
    end
  end

  private

  def only_one_ongoing_game
    already_ongoing = Game.where(status: :ongoing)
    already_ongoing = already_ongoing.where.not(id: self.id) if self.persisted?

    if already_ongoing.exists?
      errors.add(:status, 'Il y a déjà une partie en cours')
    end
  end

  def from_created_to_ongoing
    return if self.status !=  :created
    self.status = :ongoing
    self.end_date = Date.today.next_day(7)
    return self
  end

  def from_ongoing_to_over(id)
    return if self.status !=  :ongoing
    self.status = :over
    self.stopped_by = id
    return self
  end

  def from_over_to_decided
    return if self.status !=  :over
    self.status = :decided
    # define winnner
    return self
  end

  def from_decided_to_archived
    return if self.status !=  :decided
    self.status = :archived
    return self
  end
end
