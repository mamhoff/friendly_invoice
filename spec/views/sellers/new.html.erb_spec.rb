require 'rails_helper'

RSpec.describe "sellers/new", type: :view do
  before(:each) do
    assign(:seller, Seller.new(
      trade_party: nil
    ))
  end

  it "renders new seller form" do
    render

    assert_select "form[action=?][method=?]", sellers_path, "post" do

      assert_select "select[name=?]", "seller[trade_party_id]"
    end
  end
end
