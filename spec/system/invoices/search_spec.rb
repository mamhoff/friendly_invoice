require "rails_helper"

describe "Invoices:" do
  before do
    Rails.application.load_seed

    FactoryBot.create(:invoice,
      name: "Paul",
      issue_date: "2017-01-06")
    FactoryBot.create(:invoice,
      name: "Pete",
      issue_date: "2016-01-06",
      meta_attributes: {"mykey" => "myvalue"})
  end

  specify "searches right with terms", :js, :logged_in do
    visit invoices_path(q: {with_terms: "paul"})
    expect(page).to have_content "Paul"
    expect(page).not_to have_content "Pete"

    visit invoices_path(q: {with_terms: "Pete"})
    expect(page).to have_content "Pete"
    expect(page).not_to have_content "Paul"
  end

  specify "filters right by issue_date", :js, :logged_in do
    visit invoices_path(q: {issue_date_gteq: "2016-01-07"})
    expect(page).to have_content "Paul"
    expect(page).not_to have_content "Pete"

    visit invoices_path(q: {issue_date_gteq: "2016-01-06"})
    expect(page).to have_content "Paul"
    expect(page).to have_content "Pete"

    visit invoices_path(q: {issue_date_lteq: "2016-01-07"})
    expect(page).to have_content "Pete"
    expect(page).not_to have_content "Paul"
  end

  specify "searches right by meta_attributes with meta param", :js, :logged_in do
    visit invoices_path(meta: "mykey")
    expect(page).to have_content "Pete"
    expect(page).not_to have_content "Paul"

    visit invoices_path(meta: "mykey:myvalue")
    expect(page).to have_content "Pete"
    expect(page).not_to have_content "Paul"
  end
end
