class Api::V1::GamesController < ApplicationController

  def create
    @game = Game.new(status: :created, players: params:[:players])

    if @game.save
      @game.from_created_to_ongoing
      @game.update
      render json: { game: @game }, status: :created
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @game = Game.find(params[:id])
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
