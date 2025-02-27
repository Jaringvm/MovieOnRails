class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
    end

    create_join_table :reviews, :users do |t|
      t.index [:user_id, :review_id], unique: true
      t.index [:review_id, :user_id], unique: true
    end
  end
end
