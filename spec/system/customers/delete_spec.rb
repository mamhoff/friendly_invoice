require "rails_helper"

describe "Customers:" do
  let(:customer) { FactoryBot.create(:customer) }

  specify "User can delete a customer", :js, :logged_in do
    visit edit_customer_path(customer)

    expect(page).to have_content("Test Customer")

    accept_confirm do
      click_button "Delete"
    end

    expect(page).to have_content("Customer was successfully destroyed.")
    expect(page.current_path).to eql customers_path
    expect(page).not_to have_content("Test Customer")
  end

  specify "User cannot delete a customer with any invoices", :js, :logged_in do
    invoice = FactoryBot.create(:invoice, :paid, customer:)

    visit edit_customer_path(invoice.customer)

    accept_confirm do
      click_button "Delete"
    end

    expect(page.current_path).to eql edit_customer_path(invoice.customer)
    expect(page).to have_content("Cannot delete record because dependent invoices exist")
    expect(page).to have_content("Test Customer")
  end
end
