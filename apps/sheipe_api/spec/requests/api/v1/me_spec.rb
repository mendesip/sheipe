require 'rails_helper'

RSpec.describe "/api/v1/me", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }

  describe "GET /api/v1/me" do
    it "returns 200 with user fields" do
      get "/api/v1/me", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body).to include("id", "name", "email", "role", "created_at")
      expect(json_body).not_to have_key("password_digest")
    end

    it "returns 401 without token" do
      get "/api/v1/me"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/v1/me" do
    it "returns 200 with updated name" do
      patch "/api/v1/me", params: { name: "New Name" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq("New Name")
    end

    it "returns 422 for blank name" do
      patch "/api/v1/me", params: { name: "" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body.dig("error", "code")).to eq("validation_failed")
    end
  end
end
