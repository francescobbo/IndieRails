class AddMainMediumIdToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :main_medium_id, :uuid
    add_foreign_key :posts, :media, column: :main_medium_id, on_delete: :restrict
  end
end
