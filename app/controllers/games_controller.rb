
class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :join, :destroy]

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to root_path
  end

  def show
    @messages = Message.for_display
    @message  = current_user.messages.build
    @game = Game.find(params[:id])
    @pieces = @game.pieces
    #@pieces = current_game.pieces.order(:y_position).order(:x_position).to_a

    @black_player = @game.black_user_id
    @white_player = @game.white_user_id
  end

  def new
    @game = Game.new
  end

  def index
    @games = Game.available
    @blue_navbar = true
  end

  def create
    game = Game.new(game_params)
    game.white_user = current_user
    game.save
    redirect_to game_path(game)
  end

  def join
    @game = Game.find(params[:id])
    if @game.black_user.nil? && current_user != @game.white_user
      @game.update(black_user_id: current_user.id)
      redirect_to game_path(@game)
    else
      flash[:alert] = "I'm sorry. This game is full or you are already a player."
      redirect_to games_path
    end
  end
  
  def update
    @game = current_game
    @game.update(game_params)
    @game.reload
  end

  private

  helper_method :current_color

  def current_color
    if @black_player == current_user.id
      "BLACK"
    elsif @white_player == current_user.id
      "WHITE"
    else 
      nil
    end 
  end
  
  def current_game
    @game ||= Game.find(params[:id])
  end

  def assign_black_pieces_to_current_user
    @game.black_pieces.each do |piece|
      piece.color = 'BLACK'
      piece.save
    end
  end

  def assign_white_pieces_to_current_user
    @game.white_pieces.each do |piece|
      piece.color = 'WHITE'
      piece.save
    end
  end

  def game_params
    params.require(:game).permit(:game_id, :name, :current_user, :black_user_id, :white_user_id, :turn)
  end
end
