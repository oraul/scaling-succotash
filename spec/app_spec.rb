# frozen_string_literal: true

require 'spec_helper'

RSpec.describe App do
  describe 'GET /health' do
    it 'returns ok status' do
      get '/health'
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['status']).to eq('ok')
    end
  end

  describe 'unknown routes' do
    it 'returns 404 with error json' do
      get '/nonexistent'
      expect(last_response.status).to eq(404)
      body = JSON.parse(last_response.body)
      expect(body['error']).to eq('not found')
    end
  end
end
