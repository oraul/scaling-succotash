# frozen_string_literal: true

module Services
  class CreateArticle
    def initialize(user:, title:, body:)
      @user = user
      @title = title
      @body = body
    end

    def call
      raise ArgumentError, 'title is required' if @title.to_s.strip.empty?
      raise ArgumentError, 'body is required' if @body.to_s.strip.empty?

      Article.create(user_id: @user.id, title: @title, body: @body)
    end
  end
end
