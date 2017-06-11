class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'

    create_table :posts, id: :uuid do |t|
      t.integer :kind, null: false
      t.text :title
      t.text :body
      t.text :rendered_body

      t.timestamps
    end
  end
end
