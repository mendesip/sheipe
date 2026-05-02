require 'rails_helper'

RSpec.describe "/api/v1/workouts/:workout_id/exercises", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }
  let(:workout) { create(:workout, user: user) }
  let(:exercise) { create(:exercise, :system) }

  describe "POST" do
    it "adds an exercise to a workout" do
      post "/api/v1/workouts/#{workout.id}/exercises",
        params: { exercise_id: exercise.id, position: 1 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["exercise_id"]).to eq(exercise.id)
    end
  end

  describe "DELETE" do
    let!(:we) { create(:workout_exercise, workout: workout, exercise: exercise) }

    it "removes the workout exercise" do
      delete "/api/v1/workouts/#{workout.id}/exercises/#{we.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(WorkoutExercise.find_by(id: we.id)).to be_nil
    end
  end
end
