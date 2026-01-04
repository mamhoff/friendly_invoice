require "rails_helper"

RSpec.describe Common, type: :model do
  let(:tax1) { Tax.new(value: 10) }
  let(:tax2) { Tax.new(value: 40) }
  let(:item1) { Item.new(quantity: 1, unitary_cost: 0.09, taxes: [tax1]) }
  let(:item2) { Item.new(quantity: 1, unitary_cost: 0.09, taxes: [tax1, tax2]) }
  def new_common
    FactoryBot.build(:common, items: [item1, item2])
  end

  it "is not valid without a series" do
    c = FactoryBot.build(:common, customer: nil, series: nil)
    expect(c).not_to be_valid
    expect(c.errors.messages.has_key?(:series)).to be true
  end

  it "is not valid with at least a name or an identification" do
    c = FactoryBot.build(:common, customer: nil, name: nil, identification: nil)
    expect(c).not_to be_valid
  end

  it "is valid with at least a name" do
    c = FactoryBot.build(:common, identification: nil)
    expect(c).to be_valid
  end

  it "is valid with at least an identification" do
    c = FactoryBot.build(:common, name: nil)
    expect(c).to be_valid
  end

  it "is valid with valid emails" do
    c = FactoryBot.build(:common, email: "test@test.t10.de")
    expect(c).to be_valid

    c.email = "test+test@example.com"
    expect(c).to be_valid

    c.email = "test+test@test.t10.de"
    expect(c).to be_valid

    c.email = "test.test+test.test@test.com"
    expect(c).to be_valid
  end

  it "is not valid with bad e-mails" do
    email = "paquito"
    customer = FactoryBot.build(:customer, email:)
    c = FactoryBot.build(:common, customer:, email:)

    expect(c).not_to be_valid
    expect(c.errors.messages.length).to eq 1
    expect(c.errors.messages.has_key?(:email)).to be true

    c.email = "paquito@example"

    expect(c).not_to be_valid
    expect(c.errors.messages.length).to eq 1
    expect(c.errors.messages.has_key?(:email)).to be true
  end

  it "round total taxes according to currency" do
    c = new_common
    expect(c.tax_amount).to eq 0.06

    # BHD Bahrain Dinar has 3 decimals
    c.currency = "bhd"
    expect(c.tax_amount).to eq 0.054
  end

  it "has right totals after set_amounts" do
    c = new_common
    c.set_amounts
    expect(c.gross_amount).to eq 0.24
    expect(c.net_amount).to eq 0.18

    # BHD Bahrain Dinar has 3 decimals
    c.currency = "bhd"
    c.set_amounts
    expect(c.gross_amount).to eq 0.234
    expect(c.net_amount).to eq 0.18
  end
end
