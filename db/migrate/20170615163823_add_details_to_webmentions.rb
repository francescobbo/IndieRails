class AddDetailsToWebmentions < ActiveRecord::Migration[5.1]
  def change
    add_column :webmentions, :kind, :integer, null: false, default: 0
    add_column :webmentions, :author_name, :string
    add_column :webmentions, :author_image, :text
    add_column :webmentions, :author_url, :text
  end
end
