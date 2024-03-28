require 'rails_helper'
describe Api::PlayersController, type: :request do
  describe 'GET /api/players' do
    context 'test_should_list' do
      let!(:player) { FactoryBot.create(:player) }
      it 'should list players with associated skills' do
        get api_players_path

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).first['player_skills']).not_to be_empty
      end
    end

    context 'when the database is empty' do
      it 'returns an empty array' do
        Player.destroy_all
        get api_players_path
    
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
