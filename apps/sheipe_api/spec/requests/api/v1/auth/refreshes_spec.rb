require 'rails_helper'

RSpec.describe "POST /api/v1/auth/refresh", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  it "returns 200 with new access_token" do
    old_token = session.access_token
    post "/api/v1/auth/refresh", params: { refresh_token: session.refresh_token }, as: :json
    expect(response).to have_http_status(:ok)
    expect(json_body).to have_key("access_token")
    expect(json_body["access_token"]).not_to eq(old_token)
  end

  it "returns 401 for invalid refresh_token" do
    post "/api/v1/auth/refresh", params: { refresh_token: "invalid" }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig("error", "code")).to eq("unauthorized")
  end

  it "returns 401 for expired refresh_token" do
    session.update_columns(refresh_token_expires_at: 1.day.ago)
    post "/api/v1/auth/refresh", params: { refresh_token: session.refresh_token }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig("error", "code")).to eq("unauthorized")
  end
end
