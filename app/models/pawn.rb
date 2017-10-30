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
    super
  end
  
  def pawn_able?(x, y)
    valid_vertical_move?(x, y) || valid_capture?(x, y)
  end
  
  def valid_vertical_move?(x,y)
    unoccupied?(x, y) && (x - x_position).abs == 0 && (y - y_position).abs == 1 ||
    unoccupied?(x, y) && in_starting_position? && ((x - x_position). abs == 0 && (y - y_position).abs == 2)
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
  
  def last_piece_moved
    game.pieces.order(:updated_at).last 
  end
  
  def piece_at(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end
  
  
  #-----------> EN PASSANT <--------------#

  def valid_en_passant?(x, y)
    last_piece_moved.piece_type == 'Pawn' && 
    last_piece_moved.en_passant_y == y && last_piece_moved.en_passant_x == x_position
  end 

  def capture_passant(x, y)
    capture_piece_at!(last_piece_moved.x_position, last_piece_moved.y_position) if valid_en_passant?(x, y)
  end 

  def update_en_passant_position(x, y)
    return unless in_starting_position?
    dy = y - y_position 
    update_attributes(en_passant_x: x_position, en_passant_y: (y_position - dy/2))
  end 

  def in_starting_position?
    (color == 'WHITE' && y_position == 1) || (color == 'BLACK' && y_position == 6)
  end

#-----> PAWN PROMOTION <-----#

  # checks to see if a pawn is promotable.
  def promotable?(x, y)
    return true if y == 7 && color == "WHITE" || y == 0 && color == "BLACK"
    false
  end

  # performs the pawn promotion by checking to see if the pawn meets the necessary requirements.
  def promote!(x, y)
    if promotable?(x, y)
      piece = piece_at(x, y)
      piece.updat(x_position: nil, y_position: nil)
      piece.reload
      game.pieces.create(piece_type: "Queen", x_position: x, y_position: y, state: 'promoted-piece', color: color)
    else
      false
    end
  end

end