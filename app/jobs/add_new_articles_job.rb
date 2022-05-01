class AddNewArticlesJob < ApplicationJob
  queue_as :default

    def perform
      url = "https://news.ycombinator.com/"
      unparsed_page = HTTParty.get(url)
      parsed_page = Nokogiri::HTML(unparsed_page)
      all_news = parsed_page.css('a.titlelink').first(10)
      all_news.each do |one_news|
        Article.create(title: one_news.children.text, link: one_news.attributes['href'].value, date: Date.today)
      end
    end
end
