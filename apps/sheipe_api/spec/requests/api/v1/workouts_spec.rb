require 'rails_helper'

RSpec.describe "/api/v1/workouts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }

  describe "POST /api/v1/workouts" do
    it "starts a free workout (no routine)" do
      post "/api/v1/workouts", params: {}, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["routine_id"]).to be_nil
      expect(json_body["finished_at"]).to be_nil
      expect(json_body["started_at"]).to be_present
      expect(json_body["exercises"]).to eq([])
    end

    it "starts a workout from a routine and pre-populates exercises and sets" do
      routine = create(:routine, creator: user)
      ex1 = create(:exercise, :system)
      ex2 = create(:exercise, :system)
      re1 = create(:routine_exercise, routine: routine, exercise: ex1, position: 1)
      re2 = create(:routine_exercise, routine: routine, exercise: ex2, position: 2)
      3.times { |i| create(:routine_set, routine_exercise: re1, set_number: i + 1) }
      3.times { |i| create(:routine_set, routine_exercise: re2, set_number: i + 1) }

      post "/api/v1/workouts", params: { routine_id: routine.id }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["routine_id"]).to eq(routine.id)
      expect(json_body["exercises"].size).to eq(2)
      json_body["exercises"].each do |we|
        expect(we["sets"].size).to eq(3)
        we["sets"].each { |s| expect(s["completed"]).to be(false) }
      end
    end

    it "returns 422 when starting from another user's routine" do
      foreign = create(:routine, creator: other_user)
      post "/api/v1/workouts", params: { routine_id: foreign.id }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/v1/workouts" do
    it "lists workouts ordered by started_at DESC" do
      old = create(:workout, user: user, started_at: 2.days.ago)
      mid = create(:workout, user: user, started_at: 1.day.ago)
      new = create(:workout, user: user, started_at: 1.hour.ago)
      _foreign = create(:workout, user: other_user)

      get "/api/v1/workouts", headers: auth_headers
      expect(response).to have_http_status(:ok)
      ids = json_body["data"].map { |w| w["id"] }
      expect(ids).to eq([new.id, mid.id, old.id])
    end

    it "filters by date range" do
      _outside = create(:workout, user: user, started_at: Time.zone.parse("2026-03-15"))
      inside  = create(:workout, user: user, started_at: Time.zone.parse("2026-04-15"))
      get "/api/v1/workouts?start_date=2026-04-01&end_date=2026-04-30", headers: auth_headers
      ids = json_body["data"].map { |w| w["id"] }
      expect(ids).to eq([inside.id])
    end
  end

  describe "GET /api/v1/workouts/:id" do
    it "returns own workout" do
      workout = create(:workout, user: user)
      get "/api/v1/workouts/#{workout.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body["id"]).to eq(workout.id)
    end

    it "returns 403 for another user's workout" do
      foreign = create(:workout, user: other_user)
      get "/api/v1/workouts/#{foreign.id}", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/workouts/:id" do
    it "owner updates notes" do
      workout = create(:workout, user: user, notes: nil)
      patch "/api/v1/workouts/#{workout.id}", params: { notes: "Felt strong" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["notes"]).to eq("Felt strong")
    end
  end

  describe "DELETE /api/v1/workouts/:id" do
    it "owner deletes workout" do
      workout = create(:workout, user: user)
      delete "/api/v1/workouts/#{workout.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(Workout.find_by(id: workout.id)).to be_nil
    end
  end

  describe "POST /api/v1/workouts/:id/finish" do
    it "finishes an in-progress workout" do
      workout = create(:workout, user: user, finished_at: nil)
      post "/api/v1/workouts/#{workout.id}/finish", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body["finished_at"]).to be_present
    end

    it "is idempotent on already-finished workout" do
      already_at = 1.hour.ago
      workout = create(:workout, user: user, finished_at: already_at)
      post "/api/v1/workouts/#{workout.id}/finish", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(Time.zone.parse(json_body["finished_at"]).to_i).to eq(already_at.to_i)
    end

    it "returns 403 finishing another user's workout" do
      foreign = create(:workout, user: other_user)
      post "/api/v1/workouts/#{foreign.id}/finish", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
