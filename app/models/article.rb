class Article < ApplicationRecord
  validates :title, :link, :date, presence: true
  validates :link, format: URI::regexp(%w[http https])
end
