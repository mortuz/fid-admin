class Client < ApplicationRecord
  validates :name, presence: true, length: {minimum: 3, maximum: 40 }
  
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  
  validates :email, presence: true,
            length: { maximum: 120 },
            format: { with: VALID_EMAIL_REGEX }
end