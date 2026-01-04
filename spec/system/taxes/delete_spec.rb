require "rails_helper"

describe "Taxes:" do
  specify "User can delete a a tax", :js, :logged_in do
    vat = FactoryBot.create(:vat)

    visit edit_tax_path(vat)

    accept_confirm do
      click_on "Delete"
    end

    expect(page).to have_content "successfully deleted"
    expect(page.current_path).to eql taxes_path
    expect(page).not_to have_content "VAT"
  end

  specify "User can't delete a tax associated with an item", :js, :logged_in do
    FactoryBot.create(:invoice)
    vat = Tax.find_by(id: 1)

    visit edit_tax_path(vat)
    accept_confirm do
      click_on "Delete"
    end

    expect(page).to have_content "Can't delete"
    expect(page.current_path).to eql edit_tax_path(vat)
  end
end
