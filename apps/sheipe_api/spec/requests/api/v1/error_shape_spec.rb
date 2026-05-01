require 'rails_helper'

RSpec.describe 'Error shape contract', type: :request do
  describe 'unknown route' do
    it 'returns 404 with standard error shape' do
      get '/api/v1/does_not_exist'

      expect(response).to have_http_status(:not_found)
      json = response.parsed_body
      expect(json.dig('error', 'code')).to eq('not_found')
      expect(json.dig('error', 'message')).to be_a(String)
      expect(json.key?('error')).to be true
      expect(json['error'].key?('details')).to be true
    end
  end

  describe 'unhandled exception' do
    controller_class = Class.new(Api::V1::BaseController) do
      def boom
        raise 'Something broke'
      end
    end

    before do
      stub_const('Api::V1::BoomController', controller_class)
      Rails.application.routes.draw do
        get '/test_boom', to: 'api/v1/boom#boom'
        namespace :api do
          namespace :v1 do
          end
        end
        match '*path', to: 'api/v1/base#not_found', via: :all
      end
    end

    after { Rails.application.reload_routes! }

    it 'returns 500 with standard error shape and no stack trace' do
      get '/test_boom'

      expect(response).to have_http_status(:internal_server_error)
      json = response.parsed_body
      expect(json.dig('error', 'code')).to eq('internal_error')
      expect(json.dig('error', 'message')).to eq('Internal server error')
      expect(json.dig('error', 'details')).to be_nil
      expect(response.body).not_to include('backtrace')
    end
  end
end
