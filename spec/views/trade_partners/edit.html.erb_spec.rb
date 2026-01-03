require 'rails_helper'

RSpec.describe "trade_partners/edit", type: :view do
  before(:each) do
    @trade_partner = assign(:trade_partner, FactoryBot.create(:trade_partner))
  end

  it "renders the edit trade_partner form" do
    render

    assert_select "form[action=?][method=?]", trade_partner_path(@trade_partner), "post" do

      assert_select "input[name=?]", "trade_partner[name]"

      assert_select "input[name=?]", "trade_partner[legal_name]"

      assert_select "input[name=?]", "trade_partner[street]"

      assert_select "input[name=?]", "trade_partner[address_line_2]"

      assert_select "input[name=?]", "trade_partner[city]"

      assert_select "input[name=?]", "trade_partner[postal_code]"

      assert_select "input[name=?]", "trade_partner[country_code]"

      assert_select "input[name=?]", "trade_partner[vat_id]"

      assert_select "input[name=?]", "trade_partner[tax_id]"

      assert_select "input[name=?]", "trade_partner[global_id]"

      assert_select "input[name=?]", "trade_partner[global_id_scheme]"

      assert_select "input[name=?]", "trade_partner[email]"

      assert_select "input[name=?]", "trade_partner[phone]"
    end
  end
end
