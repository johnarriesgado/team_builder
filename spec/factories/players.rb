FactoryBot.define do
  factory :player do
    name { Faker::Name.name }
    position { Player::PLAYER_POSITION.sample }
    transient do
      player_skills_count { 1 }
    end

    after(:create) do |player, evaluator|
      create_list(:player_skill, evaluator.player_skills_count, player: player)
    end
  end
end
