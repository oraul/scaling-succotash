# frozen_string_literal: true

module Services
  class DeleteArticle
    def initialize(article:)
      @article = article
    end

    def call
      @article.destroy
    end
  end
end
