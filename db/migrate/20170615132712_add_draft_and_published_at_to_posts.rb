class AddDraftAndPublishedAtToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :draft, :boolean, null: false, default: false
    add_column :posts, :published_at, :datetime
  end
end
