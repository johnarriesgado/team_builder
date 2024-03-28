require 'rails_helper'
require 'support/shared_examples/invalid_parameters'

describe Api::PlayersController, type: :request do
  describe 'POST /api/players' do
    context 'when creating a new player' do
      let(:valid_params) do
        {
          "player": {
            "name": "tst",
            "position": "defender",
            "player_skills_attributes": [
              {
                "skill": "defense",
                "value": 10
              }
            ]
          }
        }
      end

      it "returns status :created when valid parameters are provided" do
        post '/api/players', params: valid_params.to_json, headers: { 'Content-Type' => 'application/json' }
        expect(response).to have_http_status(:created)
      end

      it_behaves_like 'creating with invalid params', { "player": { "name": "", "position": "defender", "player_skills_attributes": [{ "skill": "defense", "value": 10 }] } }
      it_behaves_like 'creating with invalid params', { "player": { "name": "tst", "position": "invalid_position", "player_skills_attributes": [{ "skill": "defense", "value": 10 }] } }
      it_behaves_like 'creating with invalid params', { "player": { "name": "tst", "position": "defender", "player_skills_attributes": [{ "skill": "invalid_skill", "value": 10 }] } }
    end
  end
end
