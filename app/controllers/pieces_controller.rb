require 'pry'
class PiecesController < ApplicationController

  def show
    @game = Game.find(params[:game_id])
    @pieces = @game.pieces
  end

  def update
    x = params[:piece][:x_position].to_i
    y = params[:piece][:y_position].to_i
    if current_piece.color != current_piece.game.user_turn
      render text: "It is the other player's turn"
    elsif current_piece.move_to!(x, y) == false
      render text: "Invalid Move"
    else
      render text: "Valid Move"
    end
  end
  
  def current_game
    @game ||= current_piece.game
  end

  def current_piece
    @piece ||= Piece.find(params[:id])
  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position, :piece_type, :color)
  end
end
