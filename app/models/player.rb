# frozen_string_literal: true

class Player < ApplicationRecord
  PLAYER_POSITION = %w[defender midfielder forward]

  has_many :player_skills, dependent: :destroy, inverse_of: :player
  accepts_nested_attributes_for :player_skills, allow_destroy: true

  validates :name, presence: true
  validates :position, inclusion: { in: PLAYER_POSITION, message: 'Invalid value for position: %{value}' }

  before_update :remove_old_skills

  scope :by_position, ->(position) { where(position: position) }
  scope :with_skill, ->(skill) { joins(:player_skills).where(player_skills: { skill: skill }) }
  scope :sorted_by_skill_value, ->(skill) { with_skill(skill).order("player_skills.value DESC") }

  def self.get_high_skilled(pool_of_players, no_of_players)
    pool_of_players.max_by(no_of_players) do |player|
      player.player_skills.maximum(:value) || 0
    end
  end

  private

  def remove_old_skills
    return unless player_skills.present?
    player_skills.select { |s| !s.new_record? }.each(&:destroy)
  end
end