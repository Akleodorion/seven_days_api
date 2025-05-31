class Api::V1::PlayersController < ApplicationController

  def current_player
    player = Player.includes(:challenges, :pledges).find(params[:id])
    target_pledges = Pledge.where(target_id: player.id, status: %w[ongoing done])

    render json: {
      player: player,
      challenges: player.challenges,
      pledges: player.pledges,
      target_pledges: target_pledges,
    }
  end

  def index
    @players = Player.all
    players_format = @players.map  do |player|
      {
        player: player,
        challenges: [],
        pledges: [],
        target_pledges: [],
      }
    end
    render json: { players: players_format }
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
    params.require(:player).permit(:name, :id)
  end
end
