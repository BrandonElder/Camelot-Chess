# /app/models/rook.rb
class Rook < Piece

  def valid_move?(x, y)
    super && rook_able?(x, y) ? true : false
  end

  def rook_able?(x, y)
    return false if vertical_obstruction(x,y)
    return true if horizontal_move?(x, y) || vertical_move?(x, y) || valid_capture?(x,y)
  end

  def valid_capture?(x,y)
    occupied_by_opposing_piece?(x, y) && (horizontal_move?(x, y) || vertical_move?(x, y))
  end

end
