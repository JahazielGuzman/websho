class User < ApplicationRecord
  has_secure_password
  has_many :viewings
  has_many :movies, through: :viewings
end
