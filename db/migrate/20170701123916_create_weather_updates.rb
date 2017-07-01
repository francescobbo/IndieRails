class CreateWeatherUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :weather_updates, id: :uuid do |t|
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
