require "rails_helper"

describe "Templates:" do
  before do
    @email_template = FactoryBot.create(:email_template)
    @print_template = FactoryBot.create(:print_template)
  end

  specify "User can see a couple of default templates if no change was made", :js, :logged_in do
    click_on "Account"
    click_on "Templates"

    expect(page.current_path).to eql templates_path

    expect(page).to have_content "Email Default"
    expect(page).to have_checked_field "email_default_template_#{@email_template.id}"
    expect(page).not_to have_checked_field "print_default_template_#{@email_template.id}"

    expect(page).to have_content "Print Default"
    expect(page).to have_checked_field "print_default_template_#{@print_template.id}"
    expect(page).not_to have_checked_field "email_default_template_#{@print_template.id}"
  end

  specify "User can change the default template from the list of templates", :js, :logged_in do
    visit templates_path

    find_field("email_default_template_#{@print_template.id}").click

    expect(page).to have_checked_field "print_default_template_#{@print_template.id}"
    expect(page).to have_checked_field "email_default_template_#{@print_template.id}"

    find_field("print_default_template_#{@email_template.id}").click

    expect(page).to have_checked_field "print_default_template_#{@email_template.id}"
    expect(page).to have_checked_field "email_default_template_#{@print_template.id}"
  end
end
