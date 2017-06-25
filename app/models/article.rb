class Article < Post
  validates :title, presence: true
  validates :body, presence: true

  def preview
    preview_body = body.split(/^\s*##/).first
    markdown = Redcarpet::Markdown.new(MarkdownRenderer.new, autolink: true, fenced_code_blocks: true)

    markdown.render(preview_body)
  end
end
