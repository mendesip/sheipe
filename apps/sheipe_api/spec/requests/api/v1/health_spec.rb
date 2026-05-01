require 'rails_helper'

RSpec.describe 'Health', type: :request do
  describe 'GET /up' do
    it 'returns a non-500 response' do
      get '/up'
      expect(response.status).not_to eq(500)
    end
  end
end
