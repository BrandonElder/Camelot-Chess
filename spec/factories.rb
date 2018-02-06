FactoryGirl.define do
  
  factory :game do
    name 'example game'
  end

  factory :game_white_player, class: Game do
    name 'example game'
    white_user_id 1
  end

  factory :game_black_player, class: Game do
    name 'example game'
    black_user_id 1
  end

  factory :game_full, class: Game do
    name 'example game'
    black_user_id 1
    white_user_id 2
  end

  factory :piece do
    association :game
    x_position 0
    y_position 0
    piece_type 'Rook'
    color true
    game_id 1
    state'unmoved'
  end

  factory :user do
    email { Faker::Internet.unique.email }
    password 'very_secure'
    password_confirmation 'very_secure'
    username { Faker::Internet.user_name }
    created_at Regexp.last_match(2)
    updated_at Regexp.last_match(3)
  end

  factory :king, parent: :piece do
    piece_type "King"
    x_position 1
    y_position 1
  end

  factory :bishop, parent: :piece do
    piece_type "Bishop"
    x_position 2
    y_position 2
  end
end
