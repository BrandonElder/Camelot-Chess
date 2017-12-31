require 'rails_helper'
require 'pry'

RSpec.describe Pawn, type: :model do
  let(:game) do
  Game.create(
    white_user: FactoryGirl.create(:user),
    black_user: FactoryGirl.create(:user)
  )
  end

  describe 'EN PASSANT' do
    context 'valid_en_passant method' do
      it 'will capture the white pawn if conditions are met' do
        game.pieces.delete_all
        pawn1 = Pawn.create(color: 'WHITE', x_position: 0, y_position: 1, game: game)
        pawn2 = Pawn.create(color: 'BLACK', x_position: 1, y_position: 3, game: game)
        pawn3 = Pawn.create(color: 'BLACK', x_position: 0, y_position: 4, game: game)
        game.pieces << pawn1 << pawn2 << pawn3
        pawn1.move_to!(0,3)
        pawn2.move_to!(0,2)
        pawn1.reload
        pawn2.reload
        expect(pawn1.x_position).to eq(-1)
        expect(pawn1.y_position).to eq(-1)
        expect(pawn2.x_position).to eq(0)
        expect(pawn2.y_position).to eq(2)
      end
      it 'shows valid_en_passant method works' do
        game.pieces.delete_all
        pawn1 = Pawn.create(color: 'WHITE', x_position: 0, y_position: 1, game: game)
        pawn2 = Pawn.create(color: 'BLACK', x_position: 1, y_position: 3, game: game)
        pawn3 = Pawn.create(color: 'BLACK', x_position: 0, y_position: 4, game: game)
        game.pieces << pawn1 << pawn2 << pawn3
        pawn1.move_to!(0,3)
        expect(pawn2.valid_en_passant?(0,2)).to eq(true)
      end
    end
  end

  describe 'PAWN PROMOTION' do
    context 'promotable? method' do
      it 'Should show that a pawn is promotable' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 0, y_position: 7, game_id: game)
        game.pieces << pawn
        expect(pawn.promotable?(0, 7)).to eq(true)
      end
      it 'Should show that a pawn is not promotable' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 0, y_position: 6, game_id: game)
        game.pieces << pawn
        expect(pawn.promotable?(0, 6)).to eq(false)
      end
    end
    context 'pawn promote? method' do
      it 'Promotes white pawn to white queen when moving to y_position: 7' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 6, game_id: game)
        game.pieces << pawn
        pawn.move_to!(1,7)
        expect(pawn.promote?(7)).to eq(true)
        game.reload
        expect(game.pieces.find_by(x_position: 1, y_position: 7).piece_type).to eq("Queen")
        expect(game.pieces.find_by(x_position: 1, y_position: 7).color).to eq("WHITE")
      end
      it 'Promotes black pawn to black queen when moving to y_position: 0' do
        game.pieces.delete_all
        game.update_attributes(user_turn: 'BLACK')
        pawn = Pawn.create(color: 'BLACK', x_position: 1, y_position: 1, game_id: game)
        game.pieces << pawn
        pawn.move_to!(1, 0)
        game.reload
        expect(game.pieces.find_by(x_position: 1, y_position: 0).piece_type).to eq("Queen")
        expect(game.pieces.find_by(x_position: 1, y_position: 0).color).to eq("BLACK")
      end
    end
  end

  describe 'A WHITE PAWN' do
    context 'makes a valid move' do
      it 'can move one space forward' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(1, 2)).to eq(true)
        pawn.move_to!(1,2)
        expect(pawn.y_position).to eq(2)
      end
      it 'can move two spaces forward' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(1,3)).to eq(true)
        expect(pawn.move_to!(1,3)).to eq(true)
        pawn.move_to!(1,3)
        expect(pawn.y_position).to eq(3)
      end
    end
    context 'valid_vertical_move method' do
      it 'can move one space forward' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_vertical_move?(1, 2)).to eq(true)
        expect(pawn.move_to!(1,2)).to eq(true)
        pawn.move_to!(1,2)
        
        expect(pawn.y_position).to eq(2)
      end
      it 'can move two spaces forward' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_vertical_move?(1,3)).to eq(true)
        pawn.move_to!(1,3)
        expect(pawn.y_position).to eq(3)
      end
    end
    context 'invalid move' do
      it 'can not move forward more than 2 spaces' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(1, 5)).to eq(false)
      end
      it 'can not move to a square occupied by the same color' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        rook = Rook.create(color: 'WHITE', x_position: 1, y_position: 2, game: game)
        game.pieces << pawn << rook
        expect(pawn.valid_move?(1, 2)).to eq(false)
      end
      it 'can not move horizontally' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(2, 1)).to eq(false)
      end
      it 'can not move diagonally to an unoccupied space' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 2, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(2,3)).to eq(false)
        expect(pawn.diagonal_move?(2,3)).to eq(true)
      end
      it 'can not move backwards' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(1,0)).to eq(false)
      end
    end
    context 'CAPTURE is valid' do
      it 'when the piece is one square diagonally from it' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game_id: game)
        rook = Rook.create(color: 'BLACK', x_position: 2, y_position: 2, game_id: game)
        game.pieces << pawn << rook
        pawn.move_to!(2,2)
        rook.reload
        pawn.reload
        expect(rook.x_position).to eq(-1)
        expect(rook.y_position).to eq(-1)
        expect(pawn.x_position).to eq(2)
        expect(pawn.y_position).to eq(2)
      end
      it 'when the piece is one square diagonally from it' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 4, y_position: 3, game_id: game)
        rook = Pawn.create(color: 'BLACK', x_position: 3, y_position: 4, game_id: game)
        game.pieces << pawn << rook
        pawn.move_to!(3,4)
        rook.reload
        pawn.reload
        expect(rook.x_position).to eq(-1)
        expect(rook.y_position).to eq(-1)
        expect(pawn.x_position).to eq(3)
        expect(pawn.y_position).to eq(4)
      end
      it 'when the piece is one square diagonally from it' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game_id: game)
        rook = Rook.create(color: 'BLACK', x_position: 0, y_position: 2, game_id: game)
        game.pieces << pawn << rook
        pawn.move_to!(0, 2)
        pawn.reload
        rook.reload
        expect(rook.x_position).to eq(-1)
        expect(rook.y_position).to eq(-1)
        expect(pawn.x_position).to eq(0)
        expect(pawn.y_position).to eq(2)
      end
    end
    context 'invalid capture move' do
      it 'can not move more than two spaces diagonally' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'WHITE', x_position: 1, y_position: 1, game: game)
        rook = Rook.create(color: 'BLACK', x_position: 3, y_position: 3, game: game)
        game.pieces << pawn << rook
        expect(pawn.valid_move?(3, 3)).to eq(false)
      end
    end
  end

  describe 'A BLACK PAWN' do
    context 'makes a valid move' do
      it 'moves one square forward' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 6, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(0, 5)).to eq(true)
        expect(pawn.valid_vertical_move?(0, 5)).to eq(true)
        pawn.move_to!(0,5)
        expect(pawn.y_position).to eq(5)
      end
      it 'can move two squares forward' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 6, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(0, 4)).to eq(true)
        expect(pawn.valid_vertical_move?(0, 4)).to eq(true)
        expect(pawn.pawnable?(0, 4)).to eq(true)
        expect(pawn.valid_capture?(0, 4)).to eq(false)
        pawn.move_to!(0,4)
        expect(pawn.y_position).to eq(4)
      end
    end
    context 'invalid moves' do
      it 'can not move forward more than 2 spaces' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 6, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(0, 3)).to eq false
      end
      it 'can not move to a square occupied by the same color' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 2, y_position: 6, game: game)
        rook = Rook.create(color: 'BLACK', x_position: 2, y_position: 5, game: game)
        game.pieces << pawn << rook
        expect(pawn.valid_move?(2, 5)).to eq(false)
      end
      it 'can not move horizontally' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 1, y_position: 6, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(2, 6)).to eq(false)
      end
      it 'can not move diagonally to an unoccupied space' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 1, y_position: 6, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(2, 5)).to eq(false)
      end
      it 'the pawn has officially lost its mind' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 1, y_position: 6, game: game)
        game.pieces << pawn
        expect(pawn.valid_move?(99, 99)).to eq(false)
      end
    end
    context 'CAPTURE move' do
      it 'when the piece is one square diagonally from it' do
        game.pieces.delete_all
        game.update_attributes(user_turn: 'BLACK')
        pawn = Pawn.create(color: 'BLACK', x_position: 1, y_position: 5, game: game)
        rook = Rook.create(color: 'WHITE', x_position: 2, y_position: 4, game: game)
        game.pieces << pawn << rook
        pawn.move_to!(2, 4)
        pawn.reload
        rook.reload
        expect(rook.x_position).to eq(-1)
        expect(rook.y_position).to eq(-1)
        expect(pawn.x_position).to eq(2)
        expect(pawn.y_position).to eq(4)
      end
    end
    context 'cant make a valid move if obstructed' do
      it 'when a piece is in the way in front' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 0, game: game)
        rook = Pawn.create(color: 'WHITE', x_position: 0, y_position: 1, game: game)
        game.pieces << rook << pawn
        expect(pawn.valid_move?(0, 2)).to eq false
      end
      it 'when a piece is in the way in 1 space in front' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 1, game: game)
        rook = Pawn.create(color: 'WHITE', x_position: 0, y_position: 2, game: game)
        game.pieces << rook << pawn
        expect(pawn.valid_move?(0, 2)).to eq false
      end
      it 'when a piece is in the way in 2 spaces in front' do
        game.pieces.delete_all
        pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 1, game: game)
        rook = Pawn.create(color: 'WHITE', x_position: 0, y_position: 2, game: game)
        game.pieces << rook << pawn
        expect(pawn.valid_move?(0, 3)).to eq false
      end
    end
  end
end
