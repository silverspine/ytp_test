class User < ApplicationRecord
  has_secure_password

  has_many :accounts, dependent: :destroy

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true

  after_create do |user|
    unless user.admin?
      user.accounts.create!()
    end
  end
end
