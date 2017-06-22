class Like < Post
  # Also for Reply RSVP Bookmark Repost
  validates :reply_to, presence: true, format: /\A#{URI.regexp(%w[http https])}\z/
end
