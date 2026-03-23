# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Sessions' do
  let!(:user) do
    u = User.new(name: 'Alice', email: 'alice@example.com')
    u.password = 'secret123'
    u.save
    u
  end

  describe 'POST /sessions' do
    it 'returns a token on valid credentials' do
      post '/sessions', { email: 'alice@example.com', password: 'secret123' }.to_json,
           'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(201)
      body = JSON.parse(last_response.body)
      expect(body['token']).not_to be_nil
    end

    it 'returns 401 on wrong password' do
      post '/sessions', { email: 'alice@example.com', password: 'wrong' }.to_json,
           'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(401)
    end

    it 'returns 401 on unknown email' do
      post '/sessions', { email: 'nobody@example.com', password: 'secret123' }.to_json,
           'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(401)
    end
  end

  describe 'DELETE /sessions' do
    let!(:token) { Token.generate_for(user) }

    it 'invalidates the token and returns 204' do
      delete '/sessions', nil, 'HTTP_AUTHORIZATION' => "Bearer #{token.value}"
      expect(last_response.status).to eq(204)
      expect(Token.first(value: token.value)).to be_nil
    end

    it 'returns 401 without a token' do
      delete '/sessions'
      expect(last_response.status).to eq(401)
    end
  end
end
