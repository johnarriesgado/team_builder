class Api::PlayersController < ApplicationController
  before_action :set_player, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:destroy]

  # GET /players
  def index
    @players = Player.includes(:player_skills).all
    render_json(@players)
  end

  # POST /players
  def create
    @player = Player.new(player_params)

    if @player.save
      render_json(@player, :created)
    else
      render json: { message: @player.errors.messages.values.flatten }, status: :unprocessable_entity
    end
  end

  # GET /players/:id
  def show
    render_json(@player)
  end

  # PUT /players/:id
  def update
    if @player.update(player_params)
      render_json(@player.reload, :ok)
    else
      render json: { message: @player.errors.messages.values.flatten }, status: :unprocessable_entity
    end
  end

  # DELETE /players/:id
  def destroy
    @player.destroy
    head :no_content
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    if token != Rails.application.credentials.delete_token
      render json: { error: 'Invalid token' }, status: :unauthorized
      false
    end
  end
  

  def player_params
    params.require(:player).permit(:name, :position, player_skills_attributes: [:skill, :value])
  end
end
