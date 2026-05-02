require 'rails_helper'

RSpec.describe "/api/v1/routines", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }

  describe "GET /api/v1/routines" do
    it "returns 401 without token" do
      get "/api/v1/routines"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns only own routines" do
      mine = create_list(:routine, 2, creator: user)
      _theirs = create(:routine, creator: other_user)
      get "/api/v1/routines", headers: auth_headers
      expect(response).to have_http_status(:ok)
      ids = json_body["data"].map { |r| r["id"] }
      expect(ids).to match_array(mine.map(&:id))
    end

    it "returns empty list with meta when user has none" do
      get "/api/v1/routines", headers: auth_headers
      expect(json_body["data"]).to eq([])
      expect(json_body["meta"]).to include("current_page", "total_pages")
    end
  end

  describe "GET /api/v1/routines/:id" do
    it "returns own routine with nested exercises and sets" do
      routine = create(:routine, creator: user)
      ex = create(:routine_exercise, routine: routine, position: 1)
      create(:routine_set, routine_exercise: ex, set_number: 1)
      create(:routine_set, routine_exercise: ex, set_number: 2)

      get "/api/v1/routines/#{routine.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body["id"]).to eq(routine.id)
      expect(json_body["exercises"].size).to eq(1)
      expect(json_body["exercises"].first["sets"].size).to eq(2)
    end

    it "returns 403 for another user's routine" do
      routine = create(:routine, creator: other_user)
      get "/api/v1/routines/#{routine.id}", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /api/v1/routines" do
    it "creates a routine with creator_id = current_user" do
      post "/api/v1/routines", params: { name: "Upper A", description: "test" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["creator_id"]).to eq(user.id)
      expect(json_body["name"]).to eq("Upper A")
    end

    it "returns 422 when name is blank" do
      post "/api/v1/routines", params: { name: "" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body.dig("error", "details", "name")).to be_present
    end
  end

  describe "PATCH /api/v1/routines/:id" do
    it "owner updates" do
      routine = create(:routine, creator: user, name: "Old")
      patch "/api/v1/routines/#{routine.id}", params: { name: "New" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq("New")
    end

    it "non-owner gets 403" do
      routine = create(:routine, creator: other_user)
      patch "/api/v1/routines/#{routine.id}", params: { name: "Hi" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/routines/:id" do
    it "owner deletes" do
      routine = create(:routine, creator: user)
      delete "/api/v1/routines/#{routine.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(Routine.find_by(id: routine.id)).to be_nil
    end
  end
end
