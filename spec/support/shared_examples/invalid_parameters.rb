shared_examples 'creating with invalid params' do |params|
  it "returns status :unprocessable_entity" do
    post '/api/players', params: params.to_json, headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

shared_examples 'update with invalid params' do |params|
  let!(:player) { FactoryBot.create(:player, id: 2, name: "old name") }
  it "returns status :unprocessable_entity" do
    put "/api/players/#{player.id}", params: params.to_json, headers: { 'Content-Type' => 'application/json' }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end