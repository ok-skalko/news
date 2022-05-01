class ArticlesController < ApplicationController

  def index
    @search = ArticleSearch.new(params[:search])
    @articles = @search.scope.sort_by(&:date)
    # @articles = Article.all
      # where(:date => Date.yesterday..Date.today).sort_by(&:date)

    # p '------'
    # puts params
    # p '-------'
  end
end
