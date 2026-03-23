# frozen_string_literal: true

class App < Sinatra::Base
  get '/articles' do
    page = (params[:page] || 1).to_i
    per_page = [(params[:per_page] || 20).to_i, 100].min
    offset = (page - 1) * per_page

    dataset = Article.order(Sequel.desc(:created_at))
    dataset = dataset.where(user_id: params[:user_id].to_i) if params[:user_id]

    articles = dataset.limit(per_page, offset).all
    total = dataset.count

    json articles: articles.map(&:to_h), meta: { page: page, per_page: per_page, total: total }
  end

  get '/articles/:id' do
    article = Article[params[:id].to_i]
    halt 404, json(error: 'article not found') unless article
    json article.to_h
  end

  post '/articles' do
    authenticate!
    data = JSON.parse(request.body.read)
    article = Services::CreateArticle.new(
      user: current_user,
      title: data['title'],
      body: data['body']
    ).call
    status 201
    json article.to_h
  rescue ArgumentError => e
    halt 422, json(error: e.message)
  end

  patch '/articles/:id' do
    authenticate!
    article = Article.first(id: params[:id].to_i, user_id: current_user.id)
    halt 404, json(error: 'article not found') unless article
    data = JSON.parse(request.body.read)
    article = Services::UpdateArticle.new(
      article: article,
      title: data['title'],
      body: data['body']
    ).call
    json article.to_h
  end

  delete '/articles/:id' do
    authenticate!
    article = Article.first(id: params[:id].to_i, user_id: current_user.id)
    halt 404, json(error: 'article not found') unless article
    Services::DeleteArticle.new(article: article).call
    status 204
  end
end
