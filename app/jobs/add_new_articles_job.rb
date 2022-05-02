class AddNewArticlesJob < ApplicationJob
  queue_as :default

  def perform
    parsed_page = parsed_url("https://news.ycombinator.com/front?day=#{Date.today}")
    all_news = parsed_page.css('a.titlelink')
    @list_of_articles = []
    @point_articles = []
    page = 1
    per_page = all_news.count
    while per_page == 30
      pagination_parsed_page = parsed_url("https://news.ycombinator.com/front?day=#{Date.today}&p=#{page}")
      pagination_all_news = pagination_parsed_page.css('a.titlelink')
      create_list_of_articles(pagination_all_news)
      point_all = pagination_parsed_page.css('span.score')
      point_of_articles(point_all)
      articles_with_point = add_point_to_article(@list_of_articles, @point_articles)
      per_page = pagination_all_news.count
      page += 1
    end
    top_ten_news = top_news_today(articles_with_point)
    create_articles(top_ten_news)
    send_email
  end

  private

  def parsed_url(url)
    url = url
    unparsed_page = HTTParty.get(url)
    Nokogiri::HTML(unparsed_page)
  end

  def create_list_of_articles(all_news)
    all_news.each do |one_news|
      article = {
        title: one_news.children.text,
        link:  one_news.attributes['href'].value,
      }
      @list_of_articles << article
    end
    @list_of_articles
  end

  def point_of_articles(point_all)
    point_all.each do |one_point|
      @point_articles << one_point.text.split(' ')[0].to_i
    end
    @point_articles
  end

  def add_point_to_article(articles, point_articles)
    index_of_point = 0
    articles.map do |article|
      article = [ article, point_articles[index_of_point] ]
      index_of_point += 1
      article
    end
  end

  def top_news_today(all_news_with_point)
    sorted_news = all_news_with_point.sort_by { |el| el[1]}
    sorted_news.last(10).reverse
  end

  def create_articles(top_ten_news)
    top_ten_news.each do |news|
      Article.create(title: news[0][:title], link: news[0][:link], date: Date.today)
    end
  end

  def send_email
    ArticleMailer.top_news_today.deliver_later
  end
end
