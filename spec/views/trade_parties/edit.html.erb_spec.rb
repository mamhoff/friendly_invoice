require 'rails_helper'

RSpec.describe "trade_parties/edit", type: :view do
  before(:each) do
    @trade_party = assign(:trade_party, FactoryBot.create(:trade_party))
  end

  it "renders the edit trade_party form" do
    render

    assert_select "form[action=?][method=?]", trade_party_path(@trade_party), "post" do

      assert_select "input[name=?]", "trade_party[name]"

      assert_select "input[name=?]", "trade_party[legal_name]"

      assert_select "input[name=?]", "trade_party[street]"

      assert_select "input[name=?]", "trade_party[address_line_2]"

      assert_select "input[name=?]", "trade_party[city]"

      assert_select "input[name=?]", "trade_party[postal_code]"

      assert_select "input[name=?]", "trade_party[country_code]"

      assert_select "input[name=?]", "trade_party[vat_id]"

      assert_select "input[name=?]", "trade_party[tax_id]"

      assert_select "input[name=?]", "trade_party[global_id]"

      assert_select "input[name=?]", "trade_party[global_id_scheme]"

      assert_select "input[name=?]", "trade_party[email]"

      assert_select "input[name=?]", "trade_party[phone]"
    end
  end
end
