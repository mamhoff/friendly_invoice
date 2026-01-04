require "rails_helper"

describe "Settings:" do
  before do
    Rails.cache.clear
  end

  specify "User can set a URL to be called when a new recurring invoice is generated", :js, :logged_in do
    click_on "Account"
    click_on "Hooks"

    expect(page.current_path).to eql settings_hooks_path

    fill_in "hooks_settings_event_invoice_generation_url", with: "http://www.example.com/hook"
    click_on "Save"

    expect(page.current_path).to eql settings_hooks_path
    expect(find_field("hooks_settings_event_invoice_generation_url").value).to eql "http://www.example.com/hook"
  end

  specify "User can't set a hook URL with invalid data", :js, :logged_in do
    visit settings_hooks_path

    fill_in "hooks_settings_event_invoice_generation_url", with: "hook"
    click_on "Save"

    expect(page.current_path).to eql settings_hooks_path
    expect(page).to have_content "1 error"
  end
end
