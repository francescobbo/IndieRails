require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class MarkdownRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
