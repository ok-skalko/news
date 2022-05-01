require "test_helper"

class ArticleMailerTest < ActionMailer::TestCase
  test "top_news_today" do
    mail = ArticleMailer.top_news_today
    assert_equal "Top news today", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
