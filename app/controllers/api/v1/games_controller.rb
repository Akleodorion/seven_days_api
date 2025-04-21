class Api::V1::GamesController < ApplicationController

  def create
  end

  def update
    @game = Game.find(params[:id])
    #find out step
    status = @game.status
    #trigger the right update
    #try the update

  end

  def destroy
    @game = Game.find(params[:id])
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
