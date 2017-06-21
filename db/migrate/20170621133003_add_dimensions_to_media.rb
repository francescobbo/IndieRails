class AddDimensionsToMedia < ActiveRecord::Migration[5.1]
  def change
    add_column :media, :width, :integer
    add_column :media, :height, :integer
  end
end
