class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :kind, null: false
      t.text :title
      t.text :body
      t.text :rendered_body

      t.timestamps
    end
  end
end
