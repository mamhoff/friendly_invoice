require 'rails_helper'

RSpec.describe "trade_parties/new", type: :view do
  before(:each) do
    assign(:trade_party, TradeParty.new(
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

  it "renders new trade_party form" do
    render

    assert_select "form[action=?][method=?]", trade_parties_path, "post" do

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
