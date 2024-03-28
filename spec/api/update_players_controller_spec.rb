require 'rails_helper'
require 'support/shared_examples/invalid_parameters'

describe Api::PlayersController, type: :request do
  describe 'PUT /api/players/:id' do
    let!(:player) { FactoryBot.create(:player, id: 2, name: "old name") }
    let!(:player_skill_1) { FactoryBot.create(:player_skill, value: 60, skill: 'speed', player: player) }
    let!(:player_skill_2) { FactoryBot.create(:player_skill, value: 80, skill: 'attack', player: player) }

    context 'when updating an existing player' do
      let(:valid_params) do
        {
          "name": "updated name",
          "position": "midfielder",
          "player_skills": [
            { "skill": "strength", "value": 40 },
            { "skill": "stamina", "value": 30 }
          ]
        }
      end

      it "returns status :ok when valid parameters are provided" do
        put "/api/players/#{player.id}", params: valid_params.to_json, headers: { 'Content-Type' => 'application/json' }
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'update with invalid params', { "name": "", "position": "defender", "player_skills_attributes": [{ "skill": "defense", "value": 10 }] }
      it_behaves_like 'update with invalid params', { "name": "updated tst", "position": "invalid_position", "player_skills_attributes": [{ "skill": "defense", "value": 10 }] }
      it_behaves_like 'update with invalid params', { "name": "updated tst", "position": "defender", "player_skills_attributes": [{ "skill": "invalid_skill", "value": 10 }] }
    end
  end
end
