class Payment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :invoice

  validates :date, presence: true
  validates :amount, presence: true, numericality: true

  before_save do
    self.amount = amount.round invoice.currency_precision
  end

  after_save do
    invoice.save
  end

  after_destroy do
    invoice.save
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.call(self, :date, :amount, :notes)
    end
  end
end
