require 'rails_helper'

RSpec.describe Seller, type: :model do
  it { is_expected.to belong_to(:trade_party) }
end
