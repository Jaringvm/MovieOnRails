class Movie < ApplicationRecord
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :locations

  after_create :get_id

  def self.get_id
    movie_id = id
  end
end
