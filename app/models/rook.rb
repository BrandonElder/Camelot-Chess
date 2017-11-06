# /app/models/rook.rb
class Rook < Piece

  def valid_move?(x, y)
    super && rook_able?(x, y) ? true : false
  end

  def rook_able?(x, y)
    horizontal_move?(x, y) || vertical_move?(x, y) && !occupied_by_mycolor_piece?(x, y)
  end

  def valid_capture?(x, y)
    vertical_move?(x, y) && occupied_by_opposing_piece?(x, y) ||
    horizontal_move?(x,y) && occupied_by_opposing_piece?(x, y)
  end

end
