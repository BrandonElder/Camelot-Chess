class Pawn < Piece

 # def move_to!(x, y)
  #  return unless color == game.user_turn
   # update_en_passant_position(x, y) 
   # capture_passant(x, y) #if valid_en_passant?(x, y)
    #super
  #end 


  # def is_capture?(x, y)
  #  game.space_occupied?(x, y) && ((y - y_position).abs == 1 && (x - x_position).abs == 1)
  # end
  
  def valid_move?(x, y)
    super && pawn_able?(x, y)
  end
  
  def valid_capture?(x, y)
    super
  end
  
  def move_to!(x, y)
    super
  end
  
  def pawn_able?(x, y)
    (one_square?(x, y) && vertical_move?(x, y)) || (two_squares?(x, y) && vertical_move?(x, y)) ||
    valid_capture?(x, y)
  end
  
  def one_square?(x, y)
    unoccupied?(x, y) && (x - x_position).abs == 0 && (y - y_position).abs == 1
  end

  def two_squares?(x, y)
    unoccupied?(x, y) && in_starting_position? && ((x - x_position). abs == 0 && (y - y_position).abs == 2)
  end
  
  def forward_move?(y)
    (y - y_position) < 0 && color == 'black' ||
    (y - y_position) > 0 && color == 'white'
  end
  
  def diagonal_move?(x, y)
    (y_position - y).abs == (x_position - x).abs
  end

  def vertical_move?(x, y)
    x_position == x && y_position != y
  end

  def horizontal_move?(x, y)
    (y_position == y) && (x_position != x) ? true : false
  end
  
  def last_piece_moved
    game.pieces.order(:updated_at).last 
  end 

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
      piece.update_attributes(x_position: nil, y_position: nil)
      piece.reload
      game.pieces.create(piece_type: "Queen", x_position: x, y_position: y, state: 'promoted-piece', color: color)
    else
      false
    end
  end

  private

  def change_location(x,y)
    update_attributes(x_position: x, y_position: y)
  end

  def piece_at(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end

end