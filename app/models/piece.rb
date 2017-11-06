# Piece will hold all similar logic for all pieces.
class Piece < ApplicationRecord
  after_initialize :set_default_state
  belongs_to :game
  

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
    if valid_move?(x, y) && your_turn? && capture!(x, y) != false
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
  
  def not_into_check?(x,y)
    !move_causes_check?(x,y)
  end

  def within_chessboard?(x, y)
    (x >= 0 && y >= 0 && x <= 7 && y <= 7 && x != nil && y != nil)
  end

  def horizontal_obstruction?(x_end, _y_end)
    # movement: right to left
    if x_position < x_end
      (x_position + 1).upto(x_end - 1) do |x|
        return true if space_occupied?(x, y_position)
      end
    # movement: left to right
    elsif x_position > x_end
      (x_position - 1).downto(x_end + 1) do |x|
        return true if space_occupied?(x, y_position)
      end
    end
    false
  end

  def vertical_obstruction(x_end, y_end)
    # path is vertical down
    if y_position < y_end
      (y_position + 1).upto(y_end - 1) do |y|
        return true if space_occupied?(x_position, y)
      end
    # path is vertical up
    elsif y_position > y_end
      (y_position - 1).downto( + 1) do |y|
        return true if space_occupied?(x_position, y)
      end
    end
    false
  end

  def diagonal_obstruction(x_end, y_end)
    # path is diagonal and down
    if x_position < x_end
      (x_position + 1).upto(x_end - 1) do |x|
        delta_y = x - x_position
        y = y_end > y_position ? y_position + delta_y : y_position - delta_y
        return true if space_occupied?(x, y)
      end
    # path is diagonal and up
    elsif x_position > x_end
      (x_position - 1).downto(x_end + 1) do |x|
        delta_y = x_position - x
        y = y_end > y_position ? y_position + delta_y : y_position - delta_y
        return true if space_occupied?(x, y)
      end
    end
    false
  end

  def is_obstructed?(x, y)
    x = x
    y = y
    path = check_path(x_position, y_position, x, y)
    return horizontal_obstruction?(x, y) if path == 'horizontal'
    return vertical_obstruction(x, y) if path == 'vertical'
    return diagonal_obstruction(x, y) if path == 'diagonal'
    false
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
    space_occupied?(x, y) && (piece_at(x, y).color == color)
  end

  def occupied_by_opposing_piece?(x, y)
    space_occupied?(x, y) && (piece_at(x, y).color != color)
  end

  def piece_at(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end

  def diagonal_move?(x, y)
    !diagonal_obstruction(x, y) && (y_position - y).abs == (x_position - x).abs
  end

  def vertical_move?(x, y)
    !vertical_obstruction(x, y) && (y_position != y) && (x_position == x) ? true : false
  end

  def horizontal_move?(x, y)
    !horizontal_obstruction?(x, y) && (y_position == y) && (x_position != x) ? true : false
  end

  private

  def change_location(x,y)
    update_attributes(x_position: x, y_position: y)
  end

  def set_default_state
    self.state ||= 'unmoved'
  end
end