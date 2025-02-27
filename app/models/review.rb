class Review < ApplicationRecord
  belongs_to :movie
  has_and_belongs_to_many :users
end
