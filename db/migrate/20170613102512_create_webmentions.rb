class CreateWebmentions < ActiveRecord::Migration[5.1]
  def change
    create_table :webmentions, id: :uuid do |t|
      t.boolean :outbound, null: false
      t.text :source, null: false
      t.text :target, null: false
      t.integer :status, null: false, default: 0
      t.text :status_endpoint
      t.uuid :post_id

      t.timestamps
    end

    add_index :webmentions, [:source, :target, :outbound], unique: true
    add_foreign_key :webmentions, :posts, on_delete: :cascade
  end
end
