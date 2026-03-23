# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Users' do
  describe 'POST /users' do
    let(:params) { { name: 'Alice', email: 'alice@example.com', password: 'secret123' } }

    it 'creates a user and returns 201' do
      post '/users', params.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(201)
      body = JSON.parse(last_response.body)
      expect(body['email']).to eq('alice@example.com')
      expect(body['name']).to eq('Alice')
      expect(body).not_to have_key('password_digest')
    end

    it 'returns 422 when email is taken' do
      post '/users', params.to_json, 'CONTENT_TYPE' => 'application/json'
      post '/users', params.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)['error']).to eq('email already taken')
    end

    it 'returns 422 when name is missing' do
      post '/users', params.merge(name: '').to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(422)
    end

    it 'returns 422 when password is missing' do
      post '/users', params.merge(password: '').to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(422)
    end
  end

  describe 'GET /users/:id' do
    let!(:user) do
      u = User.new(name: 'Bob', email: 'bob@example.com')
      u.password = 'secret'
      u.save
      u
    end

    it 'returns the user' do
      get "/users/#{user.id}"
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['id']).to eq(user.id)
      expect(body['email']).to eq('bob@example.com')
    end

    it 'returns 404 for unknown user' do
      get '/users/99999'
      expect(last_response.status).to eq(404)
    end
  end
end
