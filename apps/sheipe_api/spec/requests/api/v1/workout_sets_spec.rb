require 'rails_helper'

RSpec.describe "/api/v1/workouts/:workout_id/exercises/:we_id/sets", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }
  let(:workout) { create(:workout, user: user) }
  let(:we) { create(:workout_exercise, workout: workout) }

  describe "POST" do
    it "logs a set with weight, reps, rpe, completed=true" do
      post "/api/v1/workouts/#{workout.id}/exercises/#{we.id}/sets",
        params: { set_number: 1, weight: 100.0, reps: 5, rpe: 8.0, completed: true },
        headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["weight"].to_f).to eq(100.0)
      expect(json_body["completed"]).to be(true)
    end

    it "stores completed=false when explicitly false" do
      post "/api/v1/workouts/#{workout.id}/exercises/#{we.id}/sets",
        params: { set_number: 1, weight: 100, reps: 5, completed: false },
        headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["completed"]).to be(false)
    end

    it "returns 422 when rpe out of range" do
      post "/api/v1/workouts/#{workout.id}/exercises/#{we.id}/sets",
        params: { set_number: 1, rpe: 11 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body.dig("error", "details", "rpe")).to be_present
    end
  end

  describe "PATCH" do
    let!(:set) { create(:workout_set, workout_exercise: we, weight: 100.0) }

    it "updates weight and completed flag" do
      patch "/api/v1/workouts/#{workout.id}/exercises/#{we.id}/sets/#{set.id}",
        params: { weight: 102.5, completed: true }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["weight"].to_f).to eq(102.5)
      expect(json_body["completed"]).to be(true)
    end
  end

  describe "DELETE" do
    let!(:set) { create(:workout_set, workout_exercise: we) }

    it "removes the set" do
      delete "/api/v1/workouts/#{workout.id}/exercises/#{we.id}/sets/#{set.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
