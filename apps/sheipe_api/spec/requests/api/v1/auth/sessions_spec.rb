require 'rails_helper'

RSpec.describe "POST /api/v1/auth/login", type: :request do
  let(:password) { "password123" }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  it "returns 200 with tokens and user on success" do
    post "/api/v1/auth/login", params: { email: user.email, password: password }, as: :json
    expect(response).to have_http_status(:ok)
    expect(json_body).to include("access_token", "refresh_token", "user")
    expect(json_body["user"]).to include("id", "name", "email", "role", "created_at")
  end

  it "returns 401 for wrong password" do
    post "/api/v1/auth/login", params: { email: user.email, password: "wrong" }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig("error", "message")).to eq("Invalid email or password")
  end

  it "returns 401 for unknown email (same message)" do
    post "/api/v1/auth/login", params: { email: "nobody@example.com", password: password }, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig("error", "message")).to eq("Invalid email or password")
  end
end
