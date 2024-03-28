# frozen_string_literal: true

class PlayerSkill < ApplicationRecord
  PLAYER_SKILL = %w[defense attack speed strength stamina]

  belongs_to :player, inverse_of: :player_skills

  validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :skill, inclusion: { in: PLAYER_SKILL, message: "Invalid value for skill: %{value}" }
end