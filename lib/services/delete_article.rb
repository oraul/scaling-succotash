# frozen_string_literal: true

require_relative '../concerns/loggable'

module Services
  class DeleteArticle
    include Concerns::Loggable

    def initialize(article:)
      @article = article
    end

    def call
      article_id = @article.id
      @article.destroy
      log_info('article.deleted', { article_id: article_id })
    end
  end
end
