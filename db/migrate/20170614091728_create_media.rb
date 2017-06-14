class CreateMedia < ActiveRecord::Migration[5.1]
  def change
    create_table :media do |t|
      t.attachment :file, null: false
      t.text :default_alt

      t.timestamps
    end
  end
end
