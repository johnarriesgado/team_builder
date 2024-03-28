require 'rails_helper'

describe Api::TeamsController, type: :request do
  describe 'POST /api/team/process' do
    let(:url) { '/api/team/process'  }
    context 'when selecting team' do
      let!(:player_1) { FactoryBot.create(:player, position: 'defender', player_skills_attributes: [{ skill: 'defense', value: 90 }]) }
      let!(:player_2) { FactoryBot.create(:player, position: 'defender') }
      let!(:player_3) { FactoryBot.create(:player, position: 'defender', player_skills_attributes: [{ skill: 'stamina', value: 85 }]) }

      it "selects team with sufficient players and main skill" do
        post url, params: { '_json' => [
          {
            "position": "defender",
            "mainSkill": "defense",
            "numberOfPlayers": 1
          }
        ]}
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)[0]['name']).to eq player_1.name
      end

      it "fills out team if skill holders are insufficient" do
        post url, params: { '_json' => [
          {
            "position": "defender",
            "mainSkill": "defense",
            "numberOfPlayers": 2
          }
        ]}
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)[0]['name']).to eq player_1.name
        expect(JSON.parse(response.body)[1]['name']).to eq player_3.name
      end

      it "fills out team with highest skill value holder" do
        post url, params: { '_json' => [
          {
            "position": "defender",
            "mainSkill": "speed",
            "numberOfPlayers": 1
          }
        ]}

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)[0]['name']).to eq player_1.name
      end

      it "returns error for insufficient players" do
        post url, params: { '_json' => [
          {
            "position": "midfielder",
            "mainSkill": "speed",
            "numberOfPlayers": 2
          }
        ]}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq("Insufficient number of players for position: midfielder")
      end
    end
  end
end
