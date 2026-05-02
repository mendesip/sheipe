require 'rails_helper'

RSpec.describe "/api/v1/users", type: :request do
  let(:requester) { create(:user) }
  let(:session) { create(:session, user: requester) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }
  let(:target_user) { create(:user) }

  describe "GET /api/v1/users/:id" do
    it "returns 200 with public fields (no email)" do
      get "/api/v1/users/#{target_user.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body).to include("id", "name", "role", "created_at")
      expect(json_body).not_to have_key("email")
    end

    it "returns 404 for unknown user" do
      get "/api/v1/users/#{SecureRandom.uuid}", headers: auth_headers
      expect(response).to have_http_status(:not_found)
      expect(json_body.dig("error", "code")).to eq("not_found")
    end

    it "returns 401 without token" do
      get "/api/v1/users/#{target_user.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
