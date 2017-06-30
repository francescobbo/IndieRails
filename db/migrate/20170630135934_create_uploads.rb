class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads, id: :uuid do |t|
      t.attachment :file

      t.timestamps
    end
  end
end
