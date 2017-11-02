class Pawn < Piece

  def valid_move?(x, y)
    return false if backward_move?(y)
    return false if !valid_capture?(x, y) && horizontal_move?(x)
    return true if super && pawn_able?(x, y)
  end
  
  def valid_capture?(x, y)
    diagonal_move?(x, y) && occupied_by_opposing_piece?(x, y) ? true : false
  end
  
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
  
  def pawn_able?(x, y)
    valid_vertical_move?(x, y) || valid_capture?(x, y)
  end
  
  def valid_vertical_move?(x, y)
    unoccupied?(x, y) && (x - x_position).abs == 0 && 
    (y - y_position).abs == 1 ||
    unoccupied?(x, y) && in_starting_position? && 
    ((x - x_position). abs == 0 && (y - y_position).abs == 2)
  end
  
  def backward_move?(y)
    color == "WHITE" && y_position > y ||
    color == "BLACK" && y_position < y
  end
  
  def diagonal_move?(x, y)
    (y_position - y).abs == (x_position - x).abs
  end
  
  def horizontal_move?(x)
    x_position - x.abs != 0
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
    your_turn? &&
    last_piece.piece_type == "Pawn" &&
    last_piece.move_num == 1 &&
    last_piece.y_position == (last_piece.color == 'WHITE' ? 3 : 4) &&
    diagonal_move?(x, y) && unoccupied?(x, y)
  end

#-----> PAWN PROMOTION <-----#

  def piece_at(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end
  
  def promote?(y)
    y == 6 || y == 1
  end

  # checks to see if a pawn is promotable.
  def promotable?(x, y)
    return true if y == 7 && color == "WHITE" || y == 0 && color == "BLACK"
    false
  end

  # performs the pawn promotion by checking to see if the pawn meets the necessary requirements.
  def ppromote!(x, y)
    if promotable?(x, y)
      Piece transaction do
        update(x_position: nil, y_position: nil)
        piece.reload
        game.pieces.create(piece_type: "Queen", x_position: x, y_position: y, 
                                      state: 'promoted-piece', color: color)
      end
    else
      false
    end
  end

end