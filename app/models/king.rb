# /app/models/king.rb
class King < Piece
  def valid_move?(x, y)
    if super && standard_king_move?(x, y)
      true
    elsif legal_castle_move?
      castle!
    else
      false 
    end
  end

  def find_piece(x_position, y_position)
    pieces.find_by(x_position: x_position, y_position: y_position)
  end

  def checkmate?
    # example logic
  end

  def castle!
    if can_castle_queenside?
      castle_queenside
    else can_castle_kingside?
      castle_kingside
    end
  end

  def can_castle_kingside?
    rook = game.pieces.where(piece_type: 'Rook', x_position: 7, state: 'unmoved')
    king = game.pieces.where(piece_type: 'King', x_position: 4, state: 'unmoved')
    if !rook
      return false
    elsif (rook && legal_castle_move? && no_kingside_obstruction?) &&
      (king && legal_castle_move? && no_kingside_obstruction?)
      true
    else 
      false 
    end
  end

  def castle_kingside
    white_rook = game.pieces.where(piece_type: 'Rook', x_position: 7, color: 'WHITE')
    white_king = game.pieces.where(piece_type: 'King', x_position: 4, color: 'WHITE')
    black_rook = game.pieces.where(piece_type: 'Rook', x_position: 7, color: 'BLACK')
    black_king = game.pieces.where(piece_type: 'King', x_position: 4, color: 'BLACK')

    if white_rook.present? && white_king.present?
      white_rook.update_attributes(x_position: 5, state: 'moved')
      white_king.update_attributes(x_position: 6, state: 'moved')
    elsif black_rook.present? && black_king.present?
      black_rook.update_attributes(x_position: 5, state: 'moved')
      black_king.update_attributes(x_position: 6, state: 'moved')
    else
      false
    end
  end

  def can_castle_queenside?
    rook = game.pieces.where(piece_type: 'Rook', x_position: 0, state: 'unmoved').take
    if rook.nil?
      return false
    else
      legal_castle_move? && no_queenside_obstruction?
    end
  end

  def castle_queenside
    rook = game.pieces.where(piece_type: 'Rook', x_position: 0).take
    king = game.pieces.where(piece_type: 'King', x_position: 4).take

    if rook.color == 'WHITE' && king.color == 'WHITE'
      rook.update_attributes(x_position: 3, state: 'moved')
      king.update_attributes(x_position: 2, state: 'moved')
    else rook.color == 'BLACK' && king.color == 'BLACK'
      rook.update_attributes(x_position: 3, state: 'moved')
      king.update_attributes(x_position: 2, state: 'moved')
    end
    rook.reload
    king.reload
  end

  def no_kingside_obstruction?
    (5..6).each do |x|
      return false if space_occupied?(x, y_position)
    end
    true
  end

  def no_queenside_obstruction?
    (1..3).each do |x|
      return false if space_occupied?(x, y_position)
    end
    true
  end

  private

  def standard_king_move?(x, y)
    dx = (x - x_position).abs
    dy = (y - y_position).abs
    if dx >= 2 || dy >= 2
      return false
    elsif dx == 0 && dy == 0
      return false
    else (dx <= 1) && (dy <= 1) && (dx + dy > 0)
      return true
    end
  end

  def legal_castle_move?
    king = game.pieces.where(piece_type: 'King', state: 'unmoved')
    rook = game.pieces.where(piece_type: 'Rook', state: 'unmoved')
    if king && rook
      return true
    else
      return false
    end
  end
end
