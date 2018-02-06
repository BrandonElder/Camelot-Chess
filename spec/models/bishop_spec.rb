require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) do
  Game.create(
    white_user: FactoryGirl.create(:user),
    black_user: FactoryGirl.create(:user))
  end

  def create_game_with_bishop
    Bishop.create(color: true, x_position: 4, y_position: 4, game: game)
  end

  describe 'bishop moves' do
    context 'unobstructed moves' do
      it 'returns false if moves vertically' do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(color: 'WHITE', x_position: 4, y_position: 3, game: game)
        expect(bishop.valid_move?(4,6)).to eq false
        bishop.move_to!(4,6)
        bishop.reload
        expect(bishop.y_position).to eq(3)
      end
      it 'returns false if moves horizontally' do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(color: 'WHITE', x_position: 7, y_position: 4, game: game)
        expect(bishop.valid_move?(1,4)).to eq false
        bishop.move_to!(1,4)
        bishop.reload
        expect(bishop.x_position).to eq(7)
      end
      it 'returns true if moving diagonally' do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(color: 'WHITE', x_position: 0, y_position: 0, game: game)
        expect(bishop.valid_move?(7,7)).to eq true
      end
      it 'returns false if it moves off the board' do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(color: 'WHITE', x_position: 0, y_position: 0, game: game)
        expect(bishop.valid_move?(200,15)).to eq false
      end
    end
    context 'obstructed moves' do
      it 'returns false if obstructed moving left' do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(color: 'BLACK', x_position: 7, y_position: 7, game: game)
        pawn = Pawn.create(color: 'BLACK', x_position: 4, y_position: 4, game: game)
        expect(bishop.valid_move?(0,0)).to eq false
        bishop.move_to!(0,0)
        game.reload
        expect(bishop.y_position).to eq(7)
      end
      it 'returns false if obstructed moving right' do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(color: 'WHITE', x_position: 0, y_position: 0, game: game)
        pawn = Pawn.create(color: 'WHITE', x_position: 4, y_position: 4, game: game)
        expect(bishop.valid_move?(7,7)).to eq false
        bishop.move_to!(7,7)
        game.reload
        expect(bishop.y_position).to eq(0)
      end
      context 'capture' do
        it 'makes a valid capture' do
          game = create(:game)
          game.pieces.delete_all
          bishop = Bishop.create(color: 'WHITE', x_position: 0, y_position: 0, game: game)
          pawn = Pawn.create(color: 'BLACK', x_position: 4, y_position: 4, game: game)
          bishop.move_to!(4,4)
          bishop.reload
          pawn.reload
          expect(pawn.x_position).to eq(-1)
          expect(pawn.y_position).to eq(-1)
          expect(bishop.x_position).to eq(4)
          expect(bishop.y_position).to eq(4)
        end
        it 'cannot capture if invalid move' do
          game = create(:game)
          game.pieces.delete_all
          bishop = Bishop.create(color: 'WHITE', x_position: 0, y_position: 0, game: game)
          pawn = Pawn.create(color: 'BLACK', x_position: 0, y_position: 4, game: game)
          bishop.move_to!(0,4)
          bishop.reload
          pawn.reload
          expect(pawn.x_position).to eq(0)
          expect(pawn.y_position).to eq(4)
          expect(bishop.x_position).to eq(0)
          expect(bishop.y_position).to eq(0)
        end
      end
    end
  end
end
