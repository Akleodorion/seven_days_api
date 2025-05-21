class Challenge < ApplicationRecord
  belongs_to :game, optional: true
  belongs_to :player

  validates :description, presence: true

  scope :created, -> { where(status: :created) }

  enum status: {
    created: 0,
    ongoing: 1,
    done: 2,
  }, _prefix: :status

  def next_step
    transitions = {
      created: from_created_to_ongoing,
      ongoing: from_ongoing_to_done
    }

    transitions[status.to_sym]&.call || self
  end

  def from_created_to_ongoing
    transition(expected_status: :created, new_status: :ongoing)
  end

  def from_ongoing_to_done
    transition(expected_status: :ongoing, new_status: :done)
  end

  private

  def transition(expected_status:, new_status:)
    return self unless public_send("status_#{expected_status}?")

    self.status = new_status
    self
  end
end
