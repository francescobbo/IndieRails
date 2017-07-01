class CreateLocationUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :location_updates do |t|
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.time :sunrise
      t.time :sunset
      t.float :temperature
      t.json :weather, default: {}
      t.json :wind, default: {}
      t.integer :humidity

      t.timestamps
    end
  end
end
