class Movie < ActiveRecord::Base
  attr_accessible :movie_id, :title, :rating, :review

  validates :rating, presence: true,
                 numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5}
  validates :review, presence: true, length: { maximum: 140 }

end
