require "rails_helper"

describe "Settings:" do
  before do
    Rails.cache.clear
  end

  specify "User with no API token can generate one", :js, :logged_in do
    click_on "Account"
    click_on "API Token"

    expect(page.current_path).to eql settings_api_token_path

    expect(page).to have_content "Use the button below to generate an API token."
    expect(page).not_to have_css "code.active"

    accept_confirm do
      click_button "Generate Token"
    end

    expect(page).to have_content "Use this token to authenticate your API requests:"
    expect(page.current_path).to eql settings_api_token_path
    expect(Settings.api_token).not_to be_nil
    expect(find("code.active").text).to eq Settings.api_token
  end

  specify "User with an API token can replace it by a new one", :js, :logged_in do
    FactoryBot.create :token

    visit settings_api_token_path
    expect(page).to have_content "123token"

    accept_confirm do
      click_button "Generate Token"
    end

    expect(page).to have_content("Use this token")
    expect(page.current_path).to eql settings_api_token_path
    expect(Settings.api_token).not_to be_nil
    expect(page).not_to have_content("123token")
    expect(find("code.active").text).not_to eq "123token"
  end
end
