require 'rails_helper'
require 'piece'

RSpec.describe Piece, type: :model do
  describe 'is_obstructed? method' do
    let(:game) do
    Game.create(
      white_user: FactoryGirl.create(:user),
      black_user: FactoryGirl.create(:user))
    end
    it 'should return true if obstructed horizontally to the right' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 0, y_position: 0)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 1, y_position: 0)

      expect(piece.is_obstructed?(2, 2)).to eq(true)
    end

    it 'should return true if obstructed horizontally to the left' do
      
      game = create(:game)
      game.pieces.delete_all
      rook = Rook.create(x_position: 2, y_position: 0, game: game, color: 'WHITE')
      pawn = Pawn.create(x_position: 3, y_position: 0, game: game, color: 'WHITE')
      
      expect(rook.is_obstructed?(4, 0)).to eq(true)
    end

    it 'should return true if obstructed vertically from above' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 0, y_position: 2)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 0, y_position: 1)

      expect(piece.is_obstructed?(0, 0)).to eq(true)
    end

    it 'should return true if obstructed vertically from below' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 0, y_position: 0)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 0, y_position: 1)

      expect(piece.is_obstructed?(0, 2)).to eq(true)
    end

    it 'should return true if obstructed diagonally moving down and to the left' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 3, y_position: 0)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 2, y_position: 1)

      expect(piece.is_obstructed?(1, 2)).to eq(true)
    end

    it 'should return true if obstructed diagonally moving down and to the right' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 0, y_position: 0)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 2, y_position: 2)

      expect(piece.is_obstructed?(3, 3)).to eq(true)
    end

    it 'should return true if obstructed diagonally moving up and to the right' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 1, y_position: 3)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 2, y_position: 2)

      expect(piece.is_obstructed?(3, 1)).to eq(true)
    end

    it 'should return true if obstructed diagonally moving up and to the left' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_user_id: user1.id)
      piece = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 3, y_position: 3)
      obstruction = FactoryGirl.create(:piece, game: game, color: 'WHITE', x_position: 2, y_position: 2)

      expect(piece.is_obstructed?(1, 1)).to eq(true)
    end
  end

  describe 'move_to!' do
    let(:game) do
    Game.create(
      white_user: FactoryGirl.create(:user),
      black_user: FactoryGirl.create(:user))
    end
    context 'black king' do
      it 'moves rook to queenside castled position' do
        game = create(:game)
        game.pieces.delete_all
        game.pass_turn!(game.user_turn)
        black_king = King.create(x_position: 4, y_position: 7, state: 'unmoved', game: game, color: 'BLACK')
        black_rook = Rook.create(x_position: 0, y_position: 7, state: 'unmoved', game: game, color: 'BLACK')
        black_king.move_to!(2, 0)
        black_rook.reload
        black_king.reload
        expect(black_rook.x_position).to eq(3)
        expect(black_king.x_position).to eq(2)
      end
    end
    context "when the square is unoccupied" do
      it "makes a valid move" do
        game = create(:game)
        game.pieces.delete_all
        queen = Queen.create(x_position: 1, y_position: 1, game: game, color: 'WHITE', piece_type: 'Queen')
        queen.move_to!(2, 2)
        queen.reload
        expect(queen.x_position).to eq(2)
        expect(queen.y_position).to eq(2)
      end
      it "makes a valid move" do
        game = create(:game)
        game.pieces.delete_all
        bishop = Bishop.create(x_position: 0, y_position: 0, game: game, color: 'WHITE', piece_type: 'Bishop')
        bishop.move_to!(7, 7)
        bishop.reload
        expect(bishop.x_position).to eq(7)
        expect(bishop.y_position).to eq(7)
      end
    end
    context "when the square is occupied with a piece of the same color" do
      it "does not capture a friendly piece" do
        game = create(:game)
        game.pieces.delete_all
        king = King.create(x_position: 1, y_position: 1, game: game, color: 'WHITE', piece_type: 'King')
        bishop = Bishop.create(x_position: 2, y_position: 2, game: game, color: 'WHITE', piece_type: 'Bishop')
        expect(king.valid_move?(2,2)).to eq false
        king.move_to!(2,2)
        king.reload
        expect(king.x_position).to eq(1)
        expect(king.y_position).to eq(1)
      end
    end
    context "when the square is occupied with opposing piece" do
      it "makes a valid capture" do
        game = create(:game)
        game.pieces.delete_all
        queen = Queen.create(x_position: 1, y_position: 1, color: 'WHITE', piece_type: 'Queen')
        bishop = Bishop.create(x_position: 1, y_position: 2, color: 'BLACK', piece_type: 'Bishop')
        game.pieces << [queen, bishop]
        queen.move_to!(1, 2)
        bishop.reload
        queen.reload
        expect(queen.x_position).to eq(1)
        expect(queen.y_position).to eq(2)
        expect(bishop.x_position).to eq(-1)
        expect(bishop.y_position).to eq(-1)
      end
    end
  end
  describe 'capture_opponent_causing_check?' do
    it 'True if white king enemies causing check are capturable' do
      game = create(:game)
      game.pieces.delete_all
      king = King.create(x_position: 4, y_position: 4, color: 'WHITE', game: game)
      queen = Queen.create(x_position: 5, y_position: 4, color: 'BLACK', game: game)
      expect(game.in_check?('WHITE')).to eq true
      expect(game.send(:capture_opponent_causing_check?, 'WHITE')).to eq true
    end
    it 'True if black king enemies causing check are capturable' do
      game = create(:game)
      game.pieces.delete_all
      king = King.create(x_position: 4, y_position: 4, color: 'BLACK', game: game)
      queen = Queen.create(x_position: 5, y_position: 4, color: 'WHITE', game: game)
      expect(game.in_check?('BLACK')).to eq true
      expect(game.send(:capture_opponent_causing_check?, 'BLACK')).to eq true
    end
    it 'False if white king enemies causing check are not capturable' do
      game = create(:game)
      game.pieces.delete_all
      king = King.create(x_position: 4, y_position: 4, color: 'WHITE', game: game)
      queen = Queen.create(x_position: 6, y_position: 4, color: 'BLACK', game: game)
      expect(game.in_check?('WHITE')).to eq true
      expect(game.send(:capture_opponent_causing_check?, 'WHITE')).to eq false
    end
    it 'False if black king enemies causing check are not capturable' do
      game = create(:game)
      game.pieces.delete_all
      king = King.create(x_position: 4, y_position: 4, color: 'BLACK', game: game)
      queen = Queen.create(x_position: 6, y_position: 4, color: 'WHITE', game: game)
      expect(game.in_check?('BLACK')).to eq true
      expect(game.send(:capture_opponent_causing_check?, 'BLACK')).to eq false
    end
  end
  describe 'move_to! method changes user turn' do
    before(:each) do
      @game = create(:game)
    end
    it 'Changes the turn to Black after a valid move' do
      pawn = @game.pieces.where(piece_type: 'Pawn', color: 'WHITE', x_position: 1, y_position: 1).take
      pawn.move_to!(1,2)
      @game.reload
      expect(@game.user_turn).to eq('BLACK')
    end
    it 'Does NOT change the turn to Black after an attempted move' do
      pawn = @game.pieces.where(piece_type: 'Pawn', color: 'WHITE', x_position: 1, y_position: 1).take
      pawn.move_to!(1,5)
      @game.reload
      expect(@game.user_turn).to eq('WHITE')
    end
  end
end
