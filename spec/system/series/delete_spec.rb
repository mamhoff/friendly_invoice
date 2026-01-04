require "rails_helper"

describe "Series:" do
  specify "User deletes a series", :js, :logged_in do
    series = FactoryBot.create(:series)

    visit edit_series_path(series)

    accept_confirm do
      click_button "Delete"
    end

    expect(page).to have_content("successfully destroyed")
    expect(page.current_path).to eql(series_index_path)
    expect(page).not_to have_content("A- Series")
  end

  specify "User can't delete a series with invoices", :js, :logged_in do
    invoice = FactoryBot.create(:invoice)
    series = invoice.series

    visit edit_series_path(series)
    accept_confirm do
      click_button "Delete"
    end

    expect(page).to have_content("can not be destroyed")
    expect(page.current_path).to eql(edit_series_path(series))
  end
end
