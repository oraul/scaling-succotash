# frozen_string_literal: true

module Services
  class ListArticles
    def initialize(page: 1, per_page: 20, user_id: nil)
      @page = page.to_i
      @per_page = [per_page.to_i, 100].min
      @user_id = user_id
    end

    def call
      dataset = Article.order(Sequel.desc(:created_at))
      dataset = dataset.where(user_id: @user_id.to_i) if @user_id

      articles = dataset.limit(@per_page, offset).all
      total = dataset.count

      { articles: articles, meta: { page: @page, per_page: @per_page, total: total } }
    end

    private

    def offset
      (@page - 1) * @per_page
    end
  end
end
