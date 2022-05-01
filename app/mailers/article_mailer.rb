class ArticleMailer < ApplicationMailer
  def top_news_today
    mail to: User.all.pluck(:email)
  end
end
