require "rails_helper"

describe "Invoices:" do
  specify "User can delete an invoice", :js, :logged_in do
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)
    accept_confirm(wait: 5) do
      click_on "Delete"
    end
    expect(page).to have_content("Invoice was successfully destroyed")
    expect(page.current_path).to eq invoices_path
    expect(page).not_to have_content "A-1"
  end

  specify "User can cancel deletion of an invoice", :js, :logged_in do
    invoice = FactoryBot.create(:invoice)

    visit edit_invoice_path(invoice)
    dismiss_confirm do
      click_on "Delete"
    end

    expect(page.current_path).to eq edit_invoice_path(invoice)
  end
end
