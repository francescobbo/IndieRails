class RenameSlugEn < ActiveRecord::Migration[5.1]
  def change
    rename_column :posts, :slug, :slug_en
  end
end
