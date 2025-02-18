class AddUniqueMovieIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :movies, :name, unique:true
  end
end
