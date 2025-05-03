class Api::V1::ChallengesController < ApplicationController
  before_action :set_challenge, only: %i[update destroy]
  before_action :unauthorized_action, only: %i[update destroy]

  def create
    @challenge = Challenge.new(challenge_params)
    if @challenge.save
      render json: { challenge: @challenge }, status: :ok
    else
      render json: { errors: @challenge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @challenge.update(challenge_params)
      render json: { challenge: @challenge }, status: :ok
    else
      render json: { errors: @challenge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def challenge_params
    params.require(:challenge).permit(:id, :description, :player_id)
  end

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def unauthorized_action
    return render json: { error: 'Pas autorisé' }, status: :unprocessable_entity if @challenge.player.id != params[:player_id]
  end
end
