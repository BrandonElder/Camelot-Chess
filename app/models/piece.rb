include PiecesHelper

class Piece < ApplicationRecord
  after_initialize :set_default_state
  belongs_to :game

  validates :color, presence: true
  validates :piece_type, presence: true
  validates :x_position, presence: true
  validates :y_position, presence: true
  validates :game_id, presence: true
  

  self.inheritance_column = :piece_type
  scope :bishops, -> { where(piece_type: "Bishop") }
  scope :kings,   -> { where(piece_type: "King") }
  scope :knights, -> { where(piece_type: "Knight") }
  scope :queens,  -> { where(piece_type: "Queen") }
  scope :pawns,   -> { where(piece_type: "Pawn") }
  scope :rooks,   -> { where(piece_type: "Rook") }

  def piece_image
    "#{color.downcase}_#{piece_type.downcase}.png"
  end
  
  def self.piece_types
    %w(Pawn Knight Bishop Rook Queen King)
  end
  
  def valid_move?(x, y)
    within_chessboard?(x, y) && space_available?(x,y)
  end
  
  def valid_capture?(x, y)
    diagonal_move?(x, y) && occupied_by_opposing_piece?(x, y) || 
    vertical_move?(x, y) && occupied_by_opposing_piece?(x, y) ||
    horizontal_move?(x,y) && occupied_by_opposing_piece?(x, y)
  end
  
  def capture!(x, y)
    if valid_capture?(x, y)
      opponent(x, y).update(x_position: -1, y_position: -1)
    elsif unoccupied?(x, y)
      true
    else
      false
    end
  end

  def move_to!(x, y)
    if valid_move?(x, y) && capture!(x, y) != false
      Piece.transaction do
        capture!(x, y)
        update!(x_position: x, y_position: y, move_num: +1)
      end
    game.pass_turn!(game.user_turn)
    end
  end
  
  def opponent(x, y)
    game.find_piece(x, y)
  end
  
  def your_turn?
    return false if game.user_turn != color
    true
  end

  def within_chessboard?(x, y)
    (x >= 0 && y >= 0 && x <= 7 && y <= 7 && x != nil && y != nil)
  end

  # IN CHECK METHODS

  def not_into_check?(x,y)
    !move_causes_check?(x,y)
  end
  
  def check_path(x_position, y_position, x, y)
    if y_position == y
      'horizontal'
    elsif x_position == x
      'vertical'
    elsif (y - y_position).abs == (x - x_position).abs
      'diagonal'
    end
  end

  def can_be_blocked?(color)
    checked_king = game.find_king(color)
    obstruction_array = obstructed_squares(checked_king.x_position, checked_king.y_position)
    opponents = game.opponents_pieces(!color)
    opponents.each do |opponent|
      next if opponent.piece_type == 'King'
      obstruction_array.each do |square|
        return true if opponent.valid_move?(square[0], square[1])
      end
    end
    false
  end

  def move_causes_check?(x, y)
    state = false
    ActiveRecord::Base.transaction do
      change_location(x,y)
      state = game.in_check?(color)
      raise ActiveRecord::Rollback
    end
    reload
    state
  end
  
  def space_available?(x,y)
    !occupied_by_mycolor_piece?(x, y)
  end

  def space_occupied?(x, y)
    game.pieces.where(x_position: x, y_position: y).present?
  end

  def unoccupied?(x, y)
    !space_occupied?(x, y)
  end

  def occupied_by_mycolor_piece?(x, y)
    piece = piece_at(x, y)
    space_occupied?(x, y) && piece.color == color
  end

  def occupied_by_opposing_piece?(x, y)
    space_occupied?(x, y) && (piece_at(x, y).color != color)
  end

  def piece_at(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end

  def diagonal_move?(x, y)
    !diagonal_obstruction(x, y) &&
    (y_position - y).abs == (x_position - x).abs
  end

  def vertical_move?(x, y)
    !vertical_obstruction(x, y)
    (y_position != y) && (x_position == x)
  end

  def horizontal_move?(x, y)
    !horizontal_obstruction?(x, y)
    (x_position != x) && (y_position == y)
  end

  def backward_move?(y)
    color == "WHITE" && y_position > y ||
    color == "BLACK" && y_position < y
  end

  private

  def change_location(x,y)
    update_attributes(x_position: x, y_position: y)
  end

  def set_default_state
    self.state ||= 'unmoved'
  end
end