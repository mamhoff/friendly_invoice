require 'rails_helper'

feature 'Invoices:' do
  let!(:invoice) { FactoryBot.create(:invoice, :paid) }

  background do
    Rails.application.load_seed
  end

  scenario 'User will see a preview of a paid invoice inside an iframe an can download a PDF', :js do
    visit invoices_path
    click_link invoice.to_s

    expect(page.current_path).to eql invoice_path(invoice)
    expect(page).to have_xpath('//iframe')

    # Verify the Download PDF link exists and has the correct PDF URL
    pdf_link = find_link('Download PDF')
    expect(pdf_link[:href]).to include('.pdf')
  end

  scenario 'Template url shows template', :js do
    visit print_invoice_path(invoice)
    expect(page).to have_content('Billed:')
  end

  scenario 'User can access the edit page from the print preview page', :js do
    visit invoice_path(invoice)
    click_on 'Edit'
    expect(page.current_path).to eq edit_invoice_path(invoice)
  end

  scenario 'User can download selected invoices as PDF from the invoices list', :js do
    visit invoices_path

    find_field('select_all').click

    # Wait for the action buttons to become visible after checkbox selection
    # The link text is "Download PDF" (from the translation)
    expect(page).to have_link('Download PDF', visible: :visible, wait: 5)

    # Click the download button - in a real browser this triggers a download
    # We can't verify response headers with JS driver, but we can verify
    # the action completes without error and redirects back to index
    click_on 'Download PDF'

    # After bulk PDF action, user should be redirected back to invoices index
    expect(page.current_path).to eq invoices_path
  end
end
