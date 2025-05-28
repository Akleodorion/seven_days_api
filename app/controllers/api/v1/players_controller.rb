class Api::V1::PlayersController < ApplicationController

  def current_player
    @player = Player.find(id: params[:player_id])
  end
  def index
    @players = Player.all
    render json: {players: @players }
  end

  def create
    @player = Player.new(name: params[:name])
    if @player.save
      render json: { player: @player }, status: :created
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @player = Player.find(id: params[:id])

    if @player.update(players_params)
      render json: { player: @player, message: "Les informations du joueur ont bien été modifiée" }, status: :ok
    else
      render json: { errors: @player.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def players_params
    params.require(:player).permit(:name)
  end
end
