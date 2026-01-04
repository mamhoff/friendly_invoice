require 'rails_helper'

RSpec.describe TradeParty, type: :model do
  it { is_expected.to have_many(:seller_invoices) }
end
