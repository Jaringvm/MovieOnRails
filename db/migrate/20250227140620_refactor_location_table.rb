class RefactorLocationTable < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :country, :string
    rename_column :locations, :name, :city
  end
end
