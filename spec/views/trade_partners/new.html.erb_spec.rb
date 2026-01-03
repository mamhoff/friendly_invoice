require 'rails_helper'

RSpec.describe "trade_partners/new", type: :view do
  before(:each) do
    assign(:trade_partner, TradePartner.new(
      name: "MyString",
      legal_name: "MyString",
      street: "MyString",
      address_line_2: "MyString",
      city: "MyString",
      postal_code: "MyString",
      country_code: "MyString",
      vat_id: "MyString",
      tax_id: "MyString",
      global_id: "MyString",
      global_id_scheme: "MyString",
      email: "MyString",
      phone: "MyString"
    ))
  end

  it "renders new trade_partner form" do
    render

    assert_select "form[action=?][method=?]", trade_partners_path, "post" do

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
