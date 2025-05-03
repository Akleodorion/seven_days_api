class Pledge < ApplicationRecord
  belongs_to :player
  belongs_to :game, optional: true

  enum status: {
    created: 'Crée',
    pending: 'En attente',
    ongoing: 'En cours',
    done: 'Terminé',
  }, _prefix: :status

  def next_step
    case status
    when :created
      from_created_to_pending
    when :pending
      from_pending_to_ongoing
    when :ongoing
      from_ongoing_to_done
    else
      self
    end
  end

  def from_created_to_pending
    return if self.status != :created
    self.status = :pending
    return self
  end

  def from_pending_to_ongoing
    return if self.status != :pending
    self.status = :ongoing
    return self
  end

  def from_ongoing_to_done
    return if self.status != :ongoing
    self.status = :done
    return self
  end

end
