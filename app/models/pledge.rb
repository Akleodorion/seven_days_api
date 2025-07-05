class Pledge < ApplicationRecord
  belongs_to :player
  belongs_to :game, optional: true

  validates :description, presence: true

  enum status: {
    created: 0,
    pending: 1,
    ongoing: 2,
    done: 3,
  }, _prefix: :status

  def next_step(target: nil)
    transitions = {
      created: -> { from_created_to_pending(target) },
      pending: -> { from_pending_to_ongoing },
      ongoing: -> {from_ongoing_to_done },
    }
    transitions[status.to_sym]&.call || self
  end

  def from_created_to_pending(target)
    transition(expected_status: :created, new_status: :pending) do |pledge|
      pledge.target = target
    end
  end

  def from_pending_to_ongoing
    transition(expected_status: :pending, new_status: :ongoing)
  end

  def from_ongoing_to_done
    transition(expected_status: :ongoing, new_status: :done)
  end

  private

  def transition(expected_status:, new_status:)
    return self unless public_send("status_#{expected_status}?")

    self.status = new_status
    yield(self) if block_given?
    return self
  end

end
