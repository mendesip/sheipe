require 'rails_helper'

RSpec.describe "DELETE /api/v1/auth/logout", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  it "returns 204 and destroys session" do
    token = session.access_token
    delete "/api/v1/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
    expect(response).to have_http_status(:no_content)
    expect(Session.find_by(access_token: token)).to be_nil
  end

  it "returns 401 after using the same token again" do
    token = session.access_token
    delete "/api/v1/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
    get "/api/v1/me", headers: { "Authorization" => "Bearer #{token}" }
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns 401 without Authorization header" do
    delete "/api/v1/auth/logout"
    expect(response).to have_http_status(:unauthorized)
  end
end
