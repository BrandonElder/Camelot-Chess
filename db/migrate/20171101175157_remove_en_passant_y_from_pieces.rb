class RemoveEnPassantYFromPieces < ActiveRecord::Migration[5.0]
  def change
    remove_column :pieces, :en_passant_y, :integer
  end
end
