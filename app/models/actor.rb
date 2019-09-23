class Actor < ApplicationRecord
  has_many :casts
  has_many :movies, through: :casts
end
