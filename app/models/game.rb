class Game < ApplicationRecord

  has_one :challenge # Doit avoir un challenge
  has_many :pledges # Doit avoir X pledges, 1 par participant
  has_many :players
  validate :only_one_ongoing_game, if: -> { status == 'ongoing' }
  validate :pledges_for_each_player, if: -> { status == 'created' || 'ongoing' }

  enum :status {
    created: 0,
    ongoing: 1,
    over: 2,
    decided: 3,
    archived: 4,
  }, _prefix: :status

  before_save :setup_game

  def self.active_game
    find_by(status: :ongoing)
  end

  def next_step(params)
    transitions = {
      created: -> { from_created_to_ongoing },
      ongoing: -> { from_ongoing_to_over(params[:id]) },
      over: -> { from_over_to_decided(params[:winners], params[:loosers]) },
      decided: -> { from_decided_to_archived }
    }

    transitions[status.to_sym]&.call || self
  end

  private

  def transition(expected_status:, new_status:)
    return self unless public_send("status_#{expected_status}?")

    self.status = new_status
    yield(self) if block_given?
    self
  end

  def only_one_ongoing_game
    already_ongoing = Game.where(status: :ongoing)
    already_ongoing = already_ongoing.where.not(id: self.id) if self.persisted?

    if already_ongoing.exists?
      errors.add(:status, 'Il y a déjà une partie en cours')
    end
  end

  def from_created_to_ongoing
    transition(expected_status: :created, new_status: :ongoing) do |game|
      game.end_date = Date.today + 7
    end
  end

  def from_ongoing_to_over(id)
    transition(expected_status: :ongoing, new_status: :over) do |game|
      game.stopped_by = id
    end
  end

  def from_over_to_decided(winners_ids, loosers_ids)
    transition(expected_status: :over, new_status: :decided) do |game|
      game.winners = winners_ids
      game.loosers = loosers_ids
      pick_pledge_for_loosers
      reset_unpicked_pledges
    end
  end

  def from_decided_to_archived
    transition(expected_status: :decided, new_status: :archived)
  end

  def pick_pledge_for_loosers
    available_pledges = pledges.where(target_id: nil, status: :created).to_a
    loosers.each do |id|
      pledge = available_pledges.reject { |p| p.player_id == id }.sample
      pledge.next_step(id)
    end
  end

  def reset_unpicked_pledges
    available_pledges = pledges.where(target_id: nil)
      available_pledges.each do |pledge|
        pledge.game_id = nil
      end
      update_all(available_pledges)
  end

  def pledges_for_each_player
    pledges.count == players.count
  end

  def setup_game
    select_challenge
    select_pledges
  end

  def select_challenge
    challenge = Challenge.created.sample
    raise Error, "Pas de défis disponible" if challenge.nil?

    self.challenge = challenge
  end

  def select_pledges
    players.each do |player|
      pledge = Pledge.created.where.not(player: player).sample
      raise Error, "Pas de challenge disponible pour: #{player.name}" if pledge.nil?

      pledge.next_step(player.id)
      pledges << pledge
    end
  end
end
