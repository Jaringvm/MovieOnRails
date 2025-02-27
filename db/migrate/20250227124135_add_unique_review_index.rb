class AddUniqueReviewIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :reviews, :name, unique:true
  end
end
