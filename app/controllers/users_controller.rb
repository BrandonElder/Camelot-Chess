require 'pry'
class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @my_games = my_games
    @open_games = open_games
    @joined_games = joined_games
  end

  def my_games
    my_games = Game.where(white_user_id: current_user.id) ||
                Game.where(black_user_id: current_user.id)  
  end

  def open_games
    Game.where(white_user_id: current_user.id, black_user_id: nil)
  end

  def joined_games
    Game.where(black_user_id: !nil)
  end

end