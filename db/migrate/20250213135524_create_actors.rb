class CreateActors < ActiveRecord::Migration[8.0]
  def change
    create_table :actors do |t|
      t.string :name
    end

    create_join_table :movies, :actors do |t|
      t.index [:movie_id, :actor_id], unique: true
      t.index [:actor_id, :movie_id], unique: true
    end
  end
end
