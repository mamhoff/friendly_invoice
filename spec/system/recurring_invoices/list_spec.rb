require "rails_helper"

describe "Recurring Invoices:" do
  specify "User can see a list of recurring invoices, most recent first", :logged_in do
    FactoryBot.create_list(:recurring_invoice, 2)

    visit recurring_invoices_path

    within "#js-list-form" do
      expect(find(:xpath, ".//tbody/tr[1]")["data-itemid"]).to eq "2"
      expect(find(:xpath, ".//tbody/tr[2]")["data-itemid"]).to eq "1"
    end
  end
end
