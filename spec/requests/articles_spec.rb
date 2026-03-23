# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Articles' do
  let!(:user) do
    u = User.new(name: 'Alice', email: 'alice@example.com')
    u.password = 'secret123'
    u.save
    u
  end
  let!(:token) { Token.generate_for(user) }
  let(:auth_header) { { 'HTTP_AUTHORIZATION' => "Bearer #{token.value}" } }

  def create_article(title: 'Hello', body: 'World')
    Article.create(user_id: user.id, title: title, body: body)
  end

  describe 'GET /articles' do
    it 'returns paginated articles' do
      3.times { |i| create_article(title: "Article #{i}") }
      get '/articles?per_page=2'
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['articles'].length).to eq(2)
      expect(body['meta']['total']).to eq(3)
    end

    it 'filters by user_id' do
      other = User.new(name: 'Bob', email: 'bob@example.com')
      other.password = 'secret'
      other.save
      create_article
      Article.create(user_id: other.id, title: 'Other', body: 'Body')

      get "/articles?user_id=#{user.id}"
      body = JSON.parse(last_response.body)
      expect(body['articles'].length).to eq(1)
      expect(body['articles'].first['user_id']).to eq(user.id)
    end
  end

  describe 'GET /articles/:id' do
    let!(:article) { create_article }

    it 'returns the article' do
      get "/articles/#{article.id}"
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['id']).to eq(article.id)
    end

    it 'returns 404 for unknown article' do
      get '/articles/99999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'POST /articles' do
    it 'creates an article and returns 201' do
      post '/articles', { title: 'My Post', body: 'Content here' }.to_json,
           { 'CONTENT_TYPE' => 'application/json' }.merge(auth_header)
      expect(last_response.status).to eq(201)
      body = JSON.parse(last_response.body)
      expect(body['title']).to eq('My Post')
      expect(body['user_id']).to eq(user.id)
    end

    it 'returns 401 without auth' do
      post '/articles', { title: 'My Post', body: 'Content' }.to_json,
           'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(401)
    end

    it 'returns 422 when title is missing' do
      post '/articles', { title: '', body: 'Content' }.to_json,
           { 'CONTENT_TYPE' => 'application/json' }.merge(auth_header)
      expect(last_response.status).to eq(422)
    end
  end

  describe 'PATCH /articles/:id' do
    let!(:article) { create_article }

    it 'updates the article' do
      patch "/articles/#{article.id}", { title: 'Updated' }.to_json,
            { 'CONTENT_TYPE' => 'application/json' }.merge(auth_header)
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['title']).to eq('Updated')
    end

    it 'returns 404 for another user\'s article' do
      other = User.new(name: 'Bob', email: 'bob@example.com')
      other.password = 'secret'
      other.save
      other_article = Article.create(user_id: other.id, title: 'Bob', body: 'Body')

      patch "/articles/#{other_article.id}", { title: 'Hack' }.to_json,
            { 'CONTENT_TYPE' => 'application/json' }.merge(auth_header)
      expect(last_response.status).to eq(404)
    end
  end

  describe 'DELETE /articles/:id' do
    let!(:article) { create_article }

    it 'deletes the article and returns 204' do
      delete "/articles/#{article.id}", nil, auth_header
      expect(last_response.status).to eq(204)
      expect(Article[article.id]).to be_nil
    end

    it 'returns 401 without auth' do
      delete "/articles/#{article.id}"
      expect(last_response.status).to eq(401)
    end
  end
end
