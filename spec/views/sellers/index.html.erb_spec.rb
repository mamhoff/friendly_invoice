require 'rails_helper'

RSpec.describe "sellers/index", type: :view do
  before(:each) do
    assign(:sellers, FactoryBot.create_list(:seller, 2))
  end

  it "renders a list of sellers" do
    render
    cell_selector = 'tbody>tr'
    assert_select cell_selector, count: 2
  end
end
