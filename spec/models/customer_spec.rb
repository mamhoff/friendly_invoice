require "rails_helper"

RSpec.describe Customer, type: :model do
  it "is not valid without a name or identification" do
    c = Customer.new
    expect(c).not_to be_valid
    expect(c.errors.messages.has_key?(:base)).to be true
  end

  it "is valid with a name" do
    expect(Customer.new(name: "A Customer")).to be_valid
  end

  it "is valid with an identification" do
    expect(Customer.new(identification: "123456789Z")).to be_valid
  end

  it "discard drafts and failed invoices when calculating totals" do
    customer = Customer.create(name: "A Customer")
    series = Series.create(value: "A")

    customer.invoices << FactoryBot.build(:invoice, series: series,
      items: [Item.new(quantity: 1, unitary_cost: 10)],
      payments: [Payment.new(amount: 5, date: Date.current)], draft: false)
    customer.invoices << FactoryBot.build(:invoice, series: series,
      items: [Item.new(quantity: 1, unitary_cost: 20)],
      payments: [Payment.new(amount: 10, date: Date.current)],
      draft: true)
    customer.invoices << FactoryBot.build(:invoice, series: series,
      items: [Item.new(quantity: 1, unitary_cost: 20)],
      payments: [Payment.new(amount: 10, date: Date.current)],
      failed: true)
    customer.save

    expect(customer.total).to eq 10
    expect(customer.paid).to eq 5
    expect(customer.due).to eq 5
  end

  it "is not deleted if there are pending invoices" do
    customer = Customer.new(name: "A Customer")
    customer.invoices << FactoryBot.build(:invoice, series: Series.new(value: "A"),
      items: [Item.new(quantity: 1, unitary_cost: 10)])
    customer.save
    expect(customer.destroy).to be_falsey
    expect(customer.persisted?).to be true
  end

  it "deleted, draft or failed invoices also prevent deletion" do
    series = Series.new(value: "A")
    customer = Customer.new(name: "A Customer")
    invoice_1 = customer.invoices << FactoryBot.build(:invoice, series: series,
      items: [Item.new(quantity: 1, unitary_cost: 10)],
      failed: true)
    customer.invoices << FactoryBot.build(:invoice, series: series,
      items: [Item.new(quantity: 1, unitary_cost: 10)],
      draft: true)
    customer.save

    expect { customer.destroy! }.to raise_exception(ActiveRecord::RecordNotDestroyed)
    expect(customer.destroyed?).to be false
    expect(invoice_1).to be_present
  end
end
