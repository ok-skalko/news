class ArticleMailer < ApplicationMailer
  def top_news_today
    mail from: "TopHakerNews@gmail.com", to: User.all.pluck(:email)
  end
end
