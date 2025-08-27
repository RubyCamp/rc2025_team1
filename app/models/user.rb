class User < ApplicationRecord
  validates :mail, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 72 }, confirmation: true

  has_secure_password
end
