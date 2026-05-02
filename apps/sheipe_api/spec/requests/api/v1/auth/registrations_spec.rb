require 'rails_helper'

RSpec.describe "POST /api/v1/auth/register", type: :request do
  let(:valid_params) do
    {
      name: "John Doe",
      email: "john@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "athlete"
    }
  end

  it "returns 201 with tokens and user on success" do
    post "/api/v1/auth/register", params: valid_params, as: :json
    expect(response).to have_http_status(:created)
    expect(json_body).to include("access_token", "refresh_token", "user")
    expect(json_body["user"]).to include("id", "name", "email", "role", "created_at")
  end

  it "returns 201 for trainer role" do
    post "/api/v1/auth/register", params: valid_params.merge(role: "trainer"), as: :json
    expect(response).to have_http_status(:created)
    expect(json_body["user"]["role"]).to eq("trainer")
  end

  it "returns 422 for duplicate email" do
    create(:user, email: "john@example.com")
    post "/api/v1/auth/register", params: valid_params, as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_body.dig("error", "code")).to eq("validation_failed")
    expect(json_body.dig("error", "details", "email")).to include("has already been taken")
  end

  it "returns 422 for password mismatch" do
    post "/api/v1/auth/register", params: valid_params.merge(password_confirmation: "wrong"), as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_body.dig("error", "code")).to eq("validation_failed")
  end

  it "returns 422 for admin role" do
    post "/api/v1/auth/register", params: valid_params.merge(role: "admin"), as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_body.dig("error", "code")).to eq("validation_failed")
  end

  it "returns 422 for blank name" do
    post "/api/v1/auth/register", params: valid_params.merge(name: ""), as: :json
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_body.dig("error", "details", "name")).to include("can't be blank")
  end
end
