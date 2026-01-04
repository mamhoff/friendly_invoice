require "rails_helper"

feature "Settings:" do
  before do
    Rails.cache.clear
  end

  scenario "User can configure global settings", :js do
    click_on "Account"
    click_on "Global Settings"

    expect(page.current_path).to eql settings_global_path

    select "USD", from: "global_settings_currency"
    click_on "Save"

    expect(page.current_path).to eql settings_global_path
    expect(page).to have_content "successfully saved"

    expect(Settings.currency).to eql "usd"
  end

  scenario "Can't configure global settings with invalid data", :js do
    visit settings_global_path

    fill_in "global_settings_days_to_due", with: ""

    click_on "Save"

    expect(page.current_path).to eql settings_global_path
    expect(page).to have_content "Global settings could not be saved"

    # nothing saved
    expect(Settings.days_to_due).to eql 0 # default setting
  end
end
