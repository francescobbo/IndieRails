class AddItFields < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :slug_it, :string
    add_column :posts, :title_it, :string
    add_column :posts, :body_it, :text
    add_column :posts, :rendered_body_it, :text
    add_column :posts, :main_medium_it_id, :integer
    add_column :posts, :meta_description_it, :string
  end
end
