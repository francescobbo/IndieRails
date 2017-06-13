module ApplicationHelper
  def default_meta_tags
    {
      viewport: 'width=device-width,minimum-scale=1,initial-scale=1',
      site: 'Francesco Boffa',
      reverse: true,
      separator: '|'
    }
  end
end
