require 'rails_helper'

RSpec.describe "/api/v1/routines/:routine_id/exercises", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }
  let(:routine) { create(:routine, creator: user) }
  let(:exercise) { create(:exercise, :system) }

  describe "POST" do
    it "adds an exercise to the routine" do
      post "/api/v1/routines/#{routine.id}/exercises",
        params: { exercise_id: exercise.id, position: 1 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["exercise_id"]).to eq(exercise.id)
      expect(json_body["position"]).to eq(1)
    end

    it "returns 422 when exercise is not visible to user (another user's custom)" do
      hidden = create(:exercise, creator: other_user)
      post "/api/v1/routines/#{routine.id}/exercises",
        params: { exercise_id: hidden.id, position: 1 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 403 when caller does not own the routine" do
      foreign = create(:routine, creator: other_user)
      post "/api/v1/routines/#{foreign.id}/exercises",
        params: { exercise_id: exercise.id, position: 1 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH" do
    let!(:re) { create(:routine_exercise, routine: routine, exercise: exercise, position: 1) }

    it "updates position" do
      patch "/api/v1/routines/#{routine.id}/exercises/#{re.id}",
        params: { position: 2 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["position"]).to eq(2)
    end
  end

  describe "DELETE" do
    let!(:re) { create(:routine_exercise, routine: routine, exercise: exercise) }

    it "removes the routine exercise" do
      delete "/api/v1/routines/#{routine.id}/exercises/#{re.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(RoutineExercise.find_by(id: re.id)).to be_nil
    end
  end
end
