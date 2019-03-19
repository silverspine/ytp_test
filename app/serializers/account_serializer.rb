class AccountSerializer < ActiveModel::Serializer
  attributes :id, :CLABE, :balance, :created_at, :updated_at
  has_many :movements
end
