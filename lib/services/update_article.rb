# frozen_string_literal: true

module Services
  class UpdateArticle
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
      @article
    end
  end
end
