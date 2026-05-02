require 'rails_helper'

RSpec.describe "/api/v1/exercises", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }

  describe "GET /api/v1/exercises" do
    it "returns 401 without token" do
      get "/api/v1/exercises"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns system exercises and the user's own custom exercises" do
      sys_a = create(:exercise, :system, name: "System A")
      sys_b = create(:exercise, :system, name: "System B")
      mine  = create(:exercise, creator: user, name: "Mine")
      _other = create(:exercise, creator: other_user, name: "Other")

      get "/api/v1/exercises", headers: auth_headers
      expect(response).to have_http_status(:ok)
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to match_array([sys_a.id, sys_b.id, mine.id])
      expect(json_body["meta"]).to include("current_page", "total_pages", "total_count")
    end

    it "filters by muscle_group" do
      chest = create(:exercise, :system, muscle_group: "chest", name: "Chest 1")
      _back = create(:exercise, :system, muscle_group: "back",  name: "Back 1")

      get "/api/v1/exercises?muscle_group=chest", headers: auth_headers
      expect(response).to have_http_status(:ok)
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to eq([chest.id])
    end

    it "filters by category" do
      cardio = create(:exercise, :system, category: "cardio", name: "Cardio 1")
      _strg  = create(:exercise, :system, category: "strength", name: "Strength 1")

      get "/api/v1/exercises?category=cardio", headers: auth_headers
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to eq([cardio.id])
    end

    it "filters by text query (case-insensitive name contains)" do
      bench = create(:exercise, :system, name: "Bench Press")
      _sq   = create(:exercise, :system, name: "Squat")

      get "/api/v1/exercises?query=bench", headers: auth_headers
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to eq([bench.id])
    end
  end

  describe "GET /api/v1/exercises/:id" do
    it "returns 200 for a system exercise" do
      sys = create(:exercise, :system)
      get "/api/v1/exercises/#{sys.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body).to include("id", "name", "muscle_group", "category", "is_system")
    end

    it "returns 200 for the user's own custom exercise" do
      mine = create(:exercise, creator: user)
      get "/api/v1/exercises/#{mine.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for another user's custom exercise" do
      other = create(:exercise, creator: other_user)
      get "/api/v1/exercises/#{other.id}", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for a non-existent id" do
      get "/api/v1/exercises/00000000-0000-0000-0000-000000000000", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/exercises" do
    let(:valid_params) do
      { name: "Custom Push-Up", muscle_group: "chest", category: "strength", description: "test" }
    end

    it "returns 201 with creator_id set to current user" do
      post "/api/v1/exercises", params: valid_params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["creator_id"]).to eq(user.id)
      expect(json_body["is_system"]).to be(false)
    end

    it "returns 422 when name is blank" do
      post "/api/v1/exercises", params: valid_params.merge(name: ""), headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body.dig("error", "code")).to eq("validation_failed")
      expect(json_body.dig("error", "details", "name")).to be_present
    end

    it "returns 422 for invalid muscle_group" do
      post "/api/v1/exercises", params: valid_params.merge(muscle_group: "fingers"), headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/exercises/:id" do
    it "owner updates their exercise" do
      mine = create(:exercise, creator: user, name: "Old")
      patch "/api/v1/exercises/#{mine.id}", params: { name: "New" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq("New")
    end

    it "returns 403 when non-owner attempts update" do
      other = create(:exercise, creator: other_user)
      patch "/api/v1/exercises/#{other.id}", params: { name: "Hi" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "returns 403 when non-admin attempts to update a system exercise" do
      sys = create(:exercise, :system)
      patch "/api/v1/exercises/#{sys.id}", params: { name: "Hi" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/exercises/:id" do
    it "owner deletes their exercise" do
      mine = create(:exercise, creator: user)
      delete "/api/v1/exercises/#{mine.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(Exercise.find_by(id: mine.id)).to be_nil
    end

    it "returns 403 for non-owner" do
      other = create(:exercise, creator: other_user)
      delete "/api/v1/exercises/#{other.id}", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
      expect(Exercise.find_by(id: other.id)).to be_present
    end

    it "returns 403 attempting to delete a system exercise" do
      sys = create(:exercise, :system)
      delete "/api/v1/exercises/#{sys.id}", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
