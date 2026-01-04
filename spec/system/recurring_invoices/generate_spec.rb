require "rails_helper"

describe "Recurring Invoices:" do
  specify "User can generate pending invoices on demand", :js, :logged_in do
    FactoryBot.create(:recurring_invoice)

    visit recurring_invoices_path
    click_button "Build Pending Invoices"

    expect(page).to have_content "A-1"
    expect(page.current_path).to eql invoices_path
    expect(page).to have_content Date.current.to_s
  end
end
