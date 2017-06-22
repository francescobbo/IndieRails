class Article < Post
  validates :title, presence: true
  validates :body, presence: true
end
