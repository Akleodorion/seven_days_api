class Api::V1::GamesController < ApplicationController

  def create
    ActiveRecord::Base.transaction do
      @game = Game.new(status: :ongoing, end_date: Date.today + 7)
      players = params[:players].map do |player|
        player[:id]
      end
      puts players
      if @game.save!
        players = Player.find(players) # ou récupérés dynamiquement

        players.each do |player|
          Participant.create(game: @game, player: player)
        end

        @game.reload
        @game.send(:setup_game) # appel manuel du setup si nécessaire

        render json: { game: @game }, include: ['challenge', 'pledges', 'players'], status: :created
      end
    end
    rescue Error => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
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
