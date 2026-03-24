# frozen_string_literal: true

require_relative '../concerns/loggable'

module Services
  class UpdateArticle
    include Concerns::Loggable

    def initialize(article:, title:, body:)
      @article = article
      @title = title
      @body = body
    end

    def call
      @article.update(
        title: @title || @article.title,
        body: @body || @article.body
      )
      log_info('article.updated', { article_id: @article.id })
      @article
    end
  end
end
