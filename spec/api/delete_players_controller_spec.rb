require 'rails_helper'

describe Api::PlayersController, type: :request do
  describe 'DELETE /api/players/:id' do
    let(:token) { Rails.application.credentials.delete_token }
    
    context 'when deleting a player with valid authorization' do
      let!(:player) { FactoryBot.create(:player) }

      it "returns status :no_content" do
        delete "/api/players/#{player.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when attempting to delete a player without valid authorization' do
      let!(:player) { FactoryBot.create(:player) }

      it "returns status :unauthorized" do
        delete "/api/players/#{player.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when attempting to delete a non-existent player' do
      it "returns status :not_found" do
        delete "/api/players/999", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
