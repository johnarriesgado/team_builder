FactoryBot.define do
  factory :player_skill do
    player
    skill { 'attack' }
    value { Faker::Number.between(from: 1, to: 90) }
  end
end
