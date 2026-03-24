# frozen_string_literal: true

require_relative '../concerns/loggable'

module Services
  class CreateArticle
    include Concerns::Loggable

    def initialize(user:, title:, body:)
      @user = user
      @title = title
      @body = body
    end

    def call
      raise ArgumentError, 'title is required' if @title.to_s.strip.empty?
      raise ArgumentError, 'body is required' if @body.to_s.strip.empty?

      article = Article.create(user_id: @user.id, title: @title, body: @body)
      log_info('article.created', { article_id: article.id, user_id: @user.id })
      article
    end
  end
end
