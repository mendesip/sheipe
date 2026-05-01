require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  ErrorsStruct = Struct.new(:to_hash, :full_messages)
  RecordStruct  = Struct.new(:errors)
  PolicyStruct  = Struct.new(:result)

  controller do
    def trigger_not_found   = raise(ActiveRecord::RecordNotFound)
    def trigger_bad_request = raise(ActionController::ParameterMissing.new(:field))
    def trigger_forbidden
      raise ActionPolicy::Unauthorized.new(PolicyStruct.new(nil), :show)
    end
    def trigger_invalid
      errors = ErrorsStruct.new({ name: ['is blank'] }, ['Name is blank'])
      record = RecordStruct.new(errors)
      ex = ActiveRecord::RecordInvalid.new
      ex.instance_variable_set(:@record, record)
      raise ex
    end
    def trigger_internal = raise(StandardError, 'unexpected')
  end

  before do
    routes.draw do
      get 'trigger_not_found'   => 'api/v1/base#trigger_not_found'
      get 'trigger_bad_request' => 'api/v1/base#trigger_bad_request'
      get 'trigger_forbidden'   => 'api/v1/base#trigger_forbidden'
      get 'trigger_invalid'     => 'api/v1/base#trigger_invalid'
      get 'trigger_internal'    => 'api/v1/base#trigger_internal'
    end
  end

  shared_examples 'standard error shape' do |code, status|
    it "returns #{status} with code '#{code}'" do
      expect(response).to have_http_status(status)
      json = response.parsed_body
      expect(json.dig('error', 'code')).to eq(code)
      expect(json.dig('error', 'message')).to be_a(String)
    end
  end

  describe 'rescue_from ActiveRecord::RecordNotFound' do
    before { get :trigger_not_found }
    include_examples 'standard error shape', 'not_found', :not_found
  end

  describe 'rescue_from ActionController::ParameterMissing' do
    before { get :trigger_bad_request }
    include_examples 'standard error shape', 'bad_request', :bad_request
  end

  describe 'rescue_from ActionPolicy::Unauthorized' do
    before { get :trigger_forbidden }
    include_examples 'standard error shape', 'forbidden', :forbidden
  end

  describe 'rescue_from ActiveRecord::RecordInvalid' do
    before { get :trigger_invalid }
    include_examples 'standard error shape', 'validation_failed', :unprocessable_entity

    it 'includes field-level details' do
      json = response.parsed_body
      expect(json.dig('error', 'details')).to be_a(Hash)
    end
  end

  describe 'rescue_from StandardError' do
    before { get :trigger_internal }
    include_examples 'standard error shape', 'internal_error', :internal_server_error

    it 'does not expose stack trace' do
      expect(response.body).not_to include('backtrace')
    end
  end
end
