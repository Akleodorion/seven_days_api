class Api::V1::GamesController < ApplicationController

  def create
    @game = Game.new(status: :ongoing, players: params[:players_id])

    @game.challenge = Challenge.created.sample

    players = Player.find(id: params[:players_id])
    players.each do |player|
      @game.pledges << Pledge.where.not(player: player).sample
    end

    if @game.save
      render json: { game: @game }, status: :created
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @game = Game.find(params[:id])
    return render json: { error: "La partie en cours n'est pas la bonne."} if @game != Game.active_game
    status = @game.status
    @game = @game.next_step(params[:player_id])
    if @game.update
      render json: { game: @game, message: "La partie est passé au status: #{@game.status}" }, status: :ok
    else
      render json: { errors: @game.erros.full_messages }, status: :unprocessable_entity
    end
  end

  def active_game
    @game = Game.active_game
    render json: { game: @game }, status: :ok
  end

  private

  def games_params
    params.require(:game).permit(:status, :stopped_by, :players, :end_date)
  end

end
