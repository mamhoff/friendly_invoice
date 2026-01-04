require "rails_helper"

feature "Customers:" do
  let(:customer) { FactoryBot.create(:customer) }

  scenario "User can delete a customer", :js do
    visit edit_customer_path(customer)

    expect(page).to have_content("Test Customer")

    accept_confirm do
      click_button "Delete"
    end

    expect(page.current_path).to eql customers_path
    expect(page).to have_content("Customer was successfully destroyed.")
    expect(page).not_to have_content("Test Customer")
  end

  scenario "User cannot delete a customer with any invoices", :js do
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
