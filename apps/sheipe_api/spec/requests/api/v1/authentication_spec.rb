require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  describe "protected endpoint" do
    context "without Authorization header" do
      it "returns 401" do
        get "/api/v1/me"
        expect(response).to have_http_status(:unauthorized)
        expect(json_body.dig("error", "code")).to eq("unauthorized")
      end
    end

    context "with invalid token" do
      it "returns 401" do
        get "/api/v1/me", headers: { "Authorization" => "Bearer invalid-token" }
        expect(response).to have_http_status(:unauthorized)
        expect(json_body.dig("error", "code")).to eq("unauthorized")
      end
    end

    context "with expired access_token" do
      it "returns 401" do
        session.update_columns(access_token_expires_at: 1.hour.ago)
        get "/api/v1/me", headers: { "Authorization" => "Bearer #{session.access_token}" }
        expect(response).to have_http_status(:unauthorized)
        expect(json_body.dig("error", "code")).to eq("unauthorized")
      end
    end
  end
end
