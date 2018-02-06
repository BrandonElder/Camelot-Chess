require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe 'create action' do
    it 'creates a new game with a white player as the current user, and redirect to games' do
      user = create(:user)
      sign_in user
      post :create, game: { name: 'example game' }
      expect(Game.first.white_user).to eq user
      expect(response).to redirect_to(game_path(Game.first))
    end
  end

  describe 'update action' do
    it 'updates game with black_player_id' do
      user = create(:user)
      sign_in user
      game = create(:game_white_player)
      put :update, id: game.id, game: { black_user_id: 1 }
      game.reload
      expect(game.black_user_id).to eq(1)
    end
  end

  describe 'join action' do
    it 'adds black_user_id after successful join' do
      game = create(:game_white_player)
      user = create(:user)
      sign_in user
      expect(game.black_user_id).to eq(nil)
      patch :join, id: game.id
      game.reload
      expect(game.black_user_id).not_to eq(nil)
    end
    it 'redirects to game_path after a successful join' do
      game = create(:game_white_player)
      black_user = create(:user)
      sign_in black_user
      patch :join, id: game.id
      expect(response).to redirect_to game_path(game)
    end
    it 'assigns black pieces to joining black_user' do
      game = create(:game_white_player)
      black_user = create(:user)
      sign_in black_user
      patch :join, id: game.id
      expect(game.black_pieces.take.color).to eq 'BLACK'
    end
  end

  describe 'destroy action' do
    it 'deletes current game and redirects user to root path' do
      game = create(:game_white_player)
      user = create(:user)
      sign_in user
      put :destroy, params: { id: game }
      expect(response).to redirect_to root_path
      
    end
  end

end
