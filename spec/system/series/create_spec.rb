require "rails_helper"

describe "Series:" do
  specify "User creates a new series", :js, :logged_in do
    visit series_index_path
    click_on "New Series"

    expect(page.current_path).to eql new_series_path

    fill_in "Name", with: "Agro supplies"
    fill_in "Value", with: "AGR"
    fill_in "First number", with: "3"
    check "Enabled"

    click_on "Save"

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("Series was successfully created")
  end

  specify "User can't create a series without a value", :js, :logged_in do
    visit new_series_path
    click_on "Save"

    expect(page.current_path).to eql(series_index_path)
    expect(page).to have_content("1 error")
  end
end
