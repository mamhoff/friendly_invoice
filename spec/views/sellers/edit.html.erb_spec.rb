require 'rails_helper'

RSpec.describe "sellers/edit", type: :view do
  let(:seller) {
    FactoryBot.create(:seller)
  }

  before(:each) do
    assign(:seller, seller)
  end

  it "renders the edit seller form" do
    render

    assert_select "form[action=?][method=?]", seller_path(seller), "post" do

      assert_select "select[name=?]", "seller[trade_party_id]"
    end
  end
end
