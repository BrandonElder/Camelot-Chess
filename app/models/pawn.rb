class Pawn < Piece
  
  def move_to!(x, y)
    if valid_en_passant?(x, y)
      Piece.transaction do
        last_piece_moved.update!(x_position: -1, y_position: -1)
        update!(x_position: x, y_position: y, move_num: move_num + 1)
      end
      game.pass_turn!(game.user_turn)
    elsif promote?(y)
      Piece.transaction do
        capture!(x, y)
        update!(
          x_position: x, y_position: y,
          piece_type: "Queen", color: color, move_num: move_num + 1)
      end
      game.pass_turn!(game.user_turn)
    else
      super
    end
  end

  def valid_move?(x, y)
    return false if backward_move?(y)
    super && pawnable?(x, y)
  end

  def pawnable?(x, y)
    valid_vertical_move?(x, y) && !diagonal_move?(x,y) || 
    valid_capture?(x, y)
  end
  
  def valid_capture?(x, y)
    diagonal_move?(x, y) && occupied_by_opposing_piece?(x, y)
  end
  
  def valid_vertical_move?(x, y)
    return false if diagonal_move?(x,y)
    unoccupied?(x, y) && (x - x_position).abs == 0 && 
    (y - y_position).abs == 1 ||
    unoccupied?(x, y) && in_starting_position? && 
    ((x - x_position).abs == 0 && (y - y_position).abs == 2)
  end
  
  def diagonal_move?(x, y)
    (y_position - y).abs == 1 && (x_position - x).abs == 1
  end
  
  def in_starting_position?
    (color == 'WHITE' && y_position == 1) || 
    (color == 'BLACK' && y_position == 6)
  end

#-----------> EN PASSANT <--------------#

  def last_piece_moved
    game.pieces.order(:updated_at).last 
  end
  
  def valid_en_passant?(x, y)
    last_piece = last_piece_moved
    your_turn? && diagonal_move?(x, y) && unoccupied?(x, y) &&
    last_piece.piece_type == "Pawn" &&
    last_piece.move_num == 1 &&
    last_piece.y_position == (last_piece.color == 'WHITE' ? 3 : 4) &&
    last_piece.x_position == x && 
    (last_piece.color == 'WHITE' && last_piece.y_position > y ||
    last_piece.color == 'BLACK' && last_piece.y_position < y)
  end

#-----> PAWN PROMOTION <-----#

# Promotion currently does not work with promote? method set to ( y == 7 || y == 0 )
# works fine if ( y == 6 || y == 1), although currently can only be promoted to a Queen
# Not sure why I can't move pieces to 0 or 7 position
# Will replace promote? method with promotable? when sorted out

  def piece_at(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end
  
  def promote?(y)
    y == 7 || y == 0
  end

  # checks to see if a pawn is promotable.
  def promotable?(x, y)
    y == 7 && color == "WHITE" || y == 0 && color == "BLACK"
  end

end