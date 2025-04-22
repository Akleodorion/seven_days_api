class Api::V1::ChallengesController < ApplicationController

  def create
    @challenge = Challenge.new(challenge_params)
    if @challenge.save
      render json: { challenge: @challenge }, status: :ok
    else
      render json: { errors: @challenge.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @challenge = Challenge.find(params[:id])
    return render json: { error: 'Pas autorisé' }, status: :unprocessable_entity if @challenge.player.id != params[:player_id]
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
end
