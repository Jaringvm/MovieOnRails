class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :name
    end

    create_join_table :movies, :locations do |t|
      t.index [:movie_id, :location_id], unique: true
      t.index [:location_id, :movie_id], unique: true
    end
  end
end
