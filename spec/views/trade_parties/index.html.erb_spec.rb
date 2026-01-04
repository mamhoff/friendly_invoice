require 'rails_helper'

RSpec.describe "trade_parties/index", type: :view do
  before(:each) do
    assign(:trade_parties, FactoryBot.create_list(:trade_party, 2))
  end

  it "renders a list of trade_parties" do
    render
    assert_select "tr>td", text: /Brillant/, count: 2
    assert_select "tr>td", text: "Berlin", count: 2
    assert_select "tr>td", text: "billing@example.com", count: 2
  end
end
