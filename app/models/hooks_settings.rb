class HooksSettings < SiwappSettings::Base
  @keys = [:event_invoice_generation_url]

  validates :event_invoice_generation_url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "is an invalid URL",
    allow_blank: true
  }
end
