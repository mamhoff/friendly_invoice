require "rails_helper"

describe "Settings:" do
  before do
    Rails.cache.clear
  end

  specify "User can update data without changing password", :js, :logged_in do
    click_on "Account"
    click_on "Profile"

    expect(page.current_path).to eql settings_profile_path

    fill_in "Name", with: "Test User Fernandez"
    fill_in "Email", with: "tu.fernandez@example.org"
    click_on "Save"

    expect(page.current_path).to eql settings_profile_path
    expect(page).to have_content "successfully saved"
    expect(find_field("user_name").value).to eq "Test User Fernandez"
    expect(find_field("user_email").value).to eq "tu.fernandez@example.org"
  end

  specify "User can update password", :js, :logged_in do
    visit settings_profile_path

    fill_in "old_password", with: "testuser"
    fill_in "user_password", with: "newpassword"
    fill_in "user_password_confirmation", with: "newpassword"
    click_on "Save"

    expect(page.current_path).to eql settings_profile_path
    expect(page).to have_content "successfully saved"
    expect(find_field("user_name").value).to eq "Test User"

    user = User.find_by!(email: "testuser@example.org")
    expect(user.authenticate("newpassword") == user).to be true
  end

  specify "User can't update password without old password", :js, :logged_in do
    visit settings_profile_path

    fill_in "old_password", with: "testuser2"
    fill_in "user_password", with: "newpassword"
    fill_in "user_password_confirmation", with: "newpassword"
    click_on "Save"

    expect(page.current_path).to eql settings_profile_path
    expect(page).to have_content "couldn't be updated"

    user = User.find_by!(email: "testuser@example.org")
    expect(user.authenticate("testuser") == user).to be true
  end

  specify "User can't update password if confirmation doesn't match", :js, :logged_in do
    visit settings_profile_path

    fill_in "old_password", with: "testuser"
    fill_in "user_password", with: "newpassword"
    fill_in "user_password_confirmation", with: "otherpassword"

    click_on "Save"

    expect(page.current_path).to eql settings_profile_path
    expect(page).to have_content "couldn't be updated"

    user = User.find_by!(email: "testuser@example.org")
    expect(user.authenticate("testuser") == user).to be true
  end
end
