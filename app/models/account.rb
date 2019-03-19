class Account < ApplicationRecord
  belongs_to :user
  has_many :movements, dependent: :destroy

  validates :CLABE, uniqueness: true, presence: true, on: :update
  validates :CLABE, uniqueness: true

  def balance
    self.movements.sum(&:amount)
  end

  before_validation :generate_CLABE, on: :create

  private

  def generate_CLABE
    if self.CLABE.blank?
      loop do
        charset = Array('0' .. '9')
        self.CLABE = Array.new(18) { charset.sample }.join
        break if Account.where(CLABE: self.CLABE).count == 0
      end
    end
  end
end
