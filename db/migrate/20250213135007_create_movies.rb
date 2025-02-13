class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.integer :year
      t.string :director
    end
  end
end
