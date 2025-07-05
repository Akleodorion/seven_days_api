class Api::V1::GamesController < ApplicationController

  def create
    @game = Game.new(status: :ongoing, end_date: Date.today + 7)
    player_ids = params[:players].map { |player| player[:id] }
    player_ids.each |player_id| do
      @game.participants.build(player: Player.find(player_id))
    end
    if @game.save!
      @game.send(:setup_game)

      render json: { game: @game }, include: ['challenge', 'pledges', 'players'], status: :created
    else
      render json: { errors: @game.errors.full_messages, status: :unprocessable_entity }
    end

  end

  def update
    @game = Game.find(params[:id])
    return render json: { error: "La partie en cours n'est pas la bonne."} if @game != Game.active_game
    status = @game.status
    @game = @game.next_step(params)
    if @game.save!
      render json: { game: @game, message: "La partie est passé au status: #{@game.status}" }, include: ['challenge', 'pledges', 'players'], status: :ok
    else
      render json: { errors: @game.erros.full_messages }, status: :unprocessable_entity
    end
  end

  def active_game
    @game = Game.active_game
    render json: { game: @game }, include: %w[challenge pledges players loosers winners], status: :ok
  end

  private

  def games_params
    params.require(:game).permit(:status, :stopped_by, :players, :end_date, :players_id)
  end

end
