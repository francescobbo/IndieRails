class Note < Post
  validates :body, presence: true

  def preview
    rendered_body
  end
end
