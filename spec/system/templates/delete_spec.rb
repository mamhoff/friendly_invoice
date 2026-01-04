require "rails_helper"

describe "Templates:" do
  specify "User can delete an existing template", :js, :logged_in do
    template = FactoryBot.create(:print_template)
    visit edit_template_path(template)

    accept_confirm do
      click_on "Delete"
    end

    expect(page).to have_content("Template was successfully destroyed")
    expect(page.current_path).to eql templates_path
    expect(page).not_to have_content "Print Default"
  end
end
