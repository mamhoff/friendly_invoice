require "rails_helper"

describe "Sessions:" do
  specify "Logged-in users can access protected routes", :logged_in do
    # Any ApplicationController child controller (except SessionsController)
    # is protected, so we can safely test only of them.
    visit invoices_path
    expect(page.current_path).to eql invoices_path
    visit root_path
    expect(page.current_path).to eql root_path
  end

  specify "Not-logged users can't access protected routes" do
    visit invoices_path
    sleep 0.2
    expect(page.current_path).to eql login_path # where are you going, sailor?
  end
end
