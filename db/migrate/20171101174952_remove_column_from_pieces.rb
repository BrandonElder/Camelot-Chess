class RemoveColumnFromPieces < ActiveRecord::Migration[5.0]
  def change
    remove_column :pieces, :en_passant_x, :integer
  end
end
