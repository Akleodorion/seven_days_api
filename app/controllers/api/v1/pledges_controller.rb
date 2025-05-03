class Api::V1::PledgesController < ApplicationController
  before_action :set_pledge, only: %i[update destroy]

  def index
    @pledges = Pledge.where(player: Player.find(params[:player_id]))
    render json: { pledges: @pledges }
  end

  def create
    @pledge = Pledge.new()
  end

  def update
  end

  def destroy
  end

  private

  def pledge_params
    params.require(:pledge).permit(:status, :description, :target_id, :player_id)
  end

  def set_pledge
    @pledge = Pledge.where(params[:id])
  end
end
