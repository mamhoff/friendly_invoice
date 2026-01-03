require 'rails_helper'

RSpec.describe "trade_partners/index", type: :view do
  before(:each) do
    assign(:trade_partners, FactoryBot.create_list(:trade_partner, 2))
  end

  it "renders a list of trade_partners" do
    render
    assert_select "tr>td", text: "Example Trading GmbH", count: 2
    assert_select "tr>td", text: "Berlin", count: 2
    assert_select "tr>td", text: "billing@example.com", count: 2
  end
end
