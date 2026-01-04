require "rails_helper"

describe "Customers:" do
  it "User can create a customer", :js, :logged_in do
    visit customers_path
    click_on "New Customer"

    expect(page.current_path).to eql new_customer_path

    fill_in "Name", with: "Test Customer"
    click_on "Save"

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("Customer was successfully created.")
    expect(page).to have_content("Test Customer")
  end

  specify "User can't create a customer without name nor identification", :js, :logged_in do
    visit new_customer_path
    click_on "Save"

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("1 error")
  end
end
