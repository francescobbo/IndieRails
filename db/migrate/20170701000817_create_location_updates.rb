class CreateLocationUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :location_updates do |t|
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false

      t.timestamps
    end
  end
end
