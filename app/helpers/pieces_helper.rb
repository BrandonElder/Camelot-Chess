module PiecesHelper

  def horizontal_obstruction?(x,y)
    if x > x_position
      (x_position + 1).upto(x - 1) do |new_x|
        return true if horizontal_move?(new_x, y) && space_occupied?(new_x, y)
      end
    elsif x < x_position
      (x_position - 1).downto(x + 1) do |new_x|
        return true if horizontal_move?(new_x, y) && space_occupied?(new_x, y)
      end
    end
    false
  end

  def vertical_obstruction(x,y)
    if y > y_position
      (y_position + 1).upto(y - 1) do |new_y|
        return true if vertical_move?(x, new_y) && space_occupied?(x, new_y)
      end
    elsif y < y_position
      (y_position - 1).downto(y + 1) do |new_y|
        return true if vertical_move?(x, new_y) && space_occupied?(x, new_y)
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
    path = check_path(x_position, y_position, x, y)
    return diagonal_obstruction(x, y) if path == 'diagonal'
    return horizontal_obstruction?(x, y) if path == 'horizontal'
    return vertical_obstruction(x, y) if path == 'vertical'
    false
  end

    # def diagonal_obstruction(x,y)
  #   if x > X_position && y > y_position
  #     (x_position + 1).upto(x - 1) do |new_x|
  #       (y_position + 1).upto(y - 1) do |new_y|
  #         return true if diagonal_move?(new_x, new_y) && space_occupied?(new_x, new_y)
  #       end
  #     end
  #   elsif x > x_position && y < y_position
  #     (x_position + 1).upto(x - 1) do |new_x|
  #       (y_position - 1).downto(y + 1) do |new_y|
  #         return true if diagonal_move?(new_x, new_y) && space_occupied?(new_x, new_y)
  #       end
  #     end
  #   elsif x < x_position && y > y_position
  #     (x_position - 1).downto(x + 1) do |new_x|
  #       (y_position + 1).upto(y - 1) do |new_y|
  #         return true if diagonal_move?(new_x, new_y) && space_occupied?(new_x, new_y)
  #       end
  #     end
  #   elsif x < x_position && y < y_position
  #     (x_position - 1).downto(x + 1) do |new_x|
  #       (y_position - 1).downto(y + 1) do |new_y|
  #         return true if diagonal_move?(new_x, new_y) && space_occupied?(new_x, new_y)
  #       end
  #     end
  #   end
  #   false
  # end
end
