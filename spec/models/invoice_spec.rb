require "rails_helper"

RSpec.describe Invoice, type: :model do
  let(:a_series) { FactoryBot.build(:series, value: "A") }
  let(:b_series) { FactoryBot.build(:series, value: "B") }
  def build_invoice(**kwargs)
    kwargs[:issue_date] = Date.current unless kwargs.has_key? :issue_date
    kwargs[:series] = a_series unless kwargs.has_key? :series

    customer = FactoryBot.create(:ncustomer)
    invoice = Invoice.new(name: customer.name, identification: customer.identification,
      customer: customer, **kwargs)
    invoice.set_amounts
    invoice
  end

  #
  # Invoice Number
  #

  it "has no invoice number if it's a draft" do
    invoice = build_invoice(draft: true, number: 1)
    invoice.save

    expect(invoice.number).to be_nil
  end

  it "gets an invoice number after saving if it's not a draft" do
    series = Series.new(value: "A", first_number: 5)
    invoice1 = build_invoice(series: series, draft: false)
    invoice1.save
    invoice2 = build_invoice(series: series, draft: false)
    invoice2.save

    expect(invoice1.number).to eq 5
    expect(invoice2.number).to eq 6
  end

  it "may have the same number as another invoice from a different series" do
    invoice1 = build_invoice(series: a_series, draft: false)
    invoice1.save

    invoice2 = build_invoice(series: b_series, draft: false)
    invoice2.save

    expect(invoice1.number).to eq 1
    expect(invoice2.number).to eq invoice1.number
  end

  it "can't have the same number as another invoice from the same series" do
    invoice1 = build_invoice(draft: false)
    expect(invoice1.save).to be true

    invoice2 = build_invoice(draft: false, series: invoice1.series, number: invoice1.number)
    expect(invoice2.save).to be false
  end

  it "retains the same number after saving" do
    invoice = build_invoice(number: 2, draft: false)
    invoice.save

    expect(invoice.number).to eq 2
  end

  it "cannot be deleted if it has a number" do
    invoice = build_invoice(draft: false)
    invoice.save

    expect(invoice.number).to eq 1

    expect { invoice.destroy! }.to raise_exception(ActiveRecord::RecordNotDestroyed)
    invoice.reload

    expect(invoice.destroyed?).to be false
  end

  #
  # Status
  #

  describe "#status" do
    let(:invoice) { FactoryBot.build(:invoice) }
    subject { invoice.get_status }

    it "returns the right status: draft" do
      expect(invoice.get_status).to eq :draft
    end

    context "when invoice has failed" do
      let(:invoice) { FactoryBot.build(:invoice, draft: false, failed: true) }

      it { is_expected.to eq(:failed) }
    end

    context "when invoice is pending" do
      let(:invoice) { FactoryBot.build(:invoice, draft: false, items: [Item.new(quantity: 1, unitary_cost: 10)], due_date: Date.current + 1) }

      it { is_expected.to eq(:pending) }
    end

    context "when invoice is past due" do
      let(:invoice) { FactoryBot.build(:invoice, draft: false, items: [Item.new(quantity: 1, unitary_cost: 10)], due_date: Date.current) }

      it { is_expected.to eq(:past_due) }
    end

    context "when invoice is paid" do
      let(:invoice) do
        FactoryBot.build(
          :invoice,
          draft: false,
          items: [Item.new(quantity: 1, unitary_cost: 10)],
          due_date: Date.current + 1,
          payments: [Payment.new(amount: 10, date: Date.current)]
        ).tap { |i| i.check_paid }
      end

      it { is_expected.to eq(:paid) }
    end
  end

  #
  # Payments
  #

  it "computes payments right" do
    # No payment received
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)])
    # invoice.save

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 0
    expect(invoice.unpaid_amount).to eq 50

    # Partially paid
    invoice.payments << Payment.new(amount: 40, date: Date.current)

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 40
    expect(invoice.unpaid_amount).to eq 10

    # Fully paid
    invoice.payments << Payment.new(amount: 10, date: Date.current)

    invoice.check_paid
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.unpaid_amount).to eq 0
  end

  it "sets paid right" do
    # A draft invoice can't be paid
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)], draft: true)

    expect(invoice.set_paid).to be false
    expect(invoice.paid).to be false

    # Remove draft switch and add a Payment; should be paid now
    invoice.payments << Payment.new(amount: 10, date: Date.current)
    invoice.check_paid
    invoice.draft = false

    expect(invoice.set_paid).to be true
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.payments.length).to eq 2
    expect(invoice.payments[1].amount).to eq 40

    # A paid invoice should not be affected
    expect(invoice.set_paid).to be false
    expect(invoice.paid).to be true
  end

  describe "#duplicate" do
    subject { invoice.duplicate }

    before do
      5.times do
        FactoryBot.create(:item, quantity: 5, unitary_cost: 10)
      end

      @invoice = build_invoice(items: Item.all)
      @invoice.save
    end

    let(:invoice) { @invoice }

    it "creates new invoice with same customer" do
      expect { subject }.to change(Invoice, :count).by(1)
      expect(Invoice.last.customer).to eq invoice.customer
    end

    it "increases item numbers" do
      expect { subject }.to change(Item, :count).by(5)
    end

    it "does not create new taxes" do
      expect { subject }.not_to change(Tax, :count)
    end

    it "is not sent by email" do
      invoice.update_columns(sent_by_email: true)

      subject

      expect(Invoice.last.sent_by_email).to eq false
    end

    it "resets paid_amount" do
      invoice.update_columns(paid_amount: 100)

      subject

      expect(Invoice.last.paid_amount).to eq 0
    end

    it "sets issue date to today date" do
      invoice.update_columns(issue_date: "2020-03-03")

      subject

      expect(Invoice.last.issue_date).to eq Date.today
    end

    it "sets amounts" do
      subject

      expect(Invoice.last.gross_amount).to eq invoice.gross_amount
    end
  end
end
