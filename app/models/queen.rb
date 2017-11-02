# /app/models/queen.rb
class Queen < Piece
  def valid_move?(x, y)
    super && !is_obstructed?(x, y) &&
    diagonal_move?(x, y) || horizontal_move?(x, y) || vertical_move?(x, y)
  end
end
