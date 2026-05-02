require 'rails_helper'

RSpec.describe "/api/v1/routines/:routine_id/exercises/:re_id/sets", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }
  let(:routine) { create(:routine, creator: user) }
  let(:re) { create(:routine_exercise, routine: routine) }

  describe "POST" do
    let(:valid_params) do
      { set_number: 1, weight: 80.0, reps: 8, rest_seconds: 90, set_type: "working" }
    end

    it "creates a set" do
      post "/api/v1/routines/#{routine.id}/exercises/#{re.id}/sets",
        params: valid_params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json_body["set_number"]).to eq(1)
      expect(json_body["set_type"]).to eq("working")
    end

    it "returns 422 for invalid set_type" do
      post "/api/v1/routines/#{routine.id}/exercises/#{re.id}/sets",
        params: valid_params.merge(set_type: "invalid"), headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH" do
    let!(:set) { create(:routine_set, routine_exercise: re, weight: 80.0, reps: 8) }

    it "updates weight and reps" do
      patch "/api/v1/routines/#{routine.id}/exercises/#{re.id}/sets/#{set.id}",
        params: { weight: 85.0, reps: 6 }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["weight"].to_f).to eq(85.0)
      expect(json_body["reps"]).to eq(6)
    end
  end

  describe "DELETE" do
    let!(:set) { create(:routine_set, routine_exercise: re) }

    it "removes the set" do
      delete "/api/v1/routines/#{routine.id}/exercises/#{re.id}/sets/#{set.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(RoutineSet.find_by(id: set.id)).to be_nil
    end
  end
end
