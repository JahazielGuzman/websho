class Movie < ApplicationRecord
  has_many :casts
  has_many :actors, through: :casts
  has_many :viewings
  has_many :users, through: :viewings
end
