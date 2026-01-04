class SellerSerializer < ActiveModel::Serializer
  attributes :id
  has_one :trade_party
end
