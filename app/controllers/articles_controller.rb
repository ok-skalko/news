class ArticlesController < ApplicationController
  def index
    @search = ArticleSearch.new(params[:search])
    @articles = @search.scope.sort_by(&:date)
  end
end
