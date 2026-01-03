FactoryBot.define do
  factory :trade_partner do
    name { "Example Trading GmbH" }
    legal_name { "Example Trading Gesellschaft mit beschränkter Haftung" }

    street { "Musterstraße 12" }
    city { "Berlin" }
    postal_code { "10115" }
    country_code { "DE" }

    vat_id { "DE123456789" }
    tax_id { "12/345/67890" }

    global_id { "4000001123452" }          # example GTIN
    global_id_scheme { "0088" }             # GS1 GLN scheme ID

    email { "billing@example.com" }
    phone { "+49-30-1234567" }

    trait :no_tax_ids do
      vat_id { nil }
      tax_id { nil }
    end

    trait :minimal do
      legal_name { nil }
      email { nil }
      phone { nil }
      global_id { nil }
      global_id_scheme { nil }
    end

    trait :foreign do
      country_code { "FR" }
      vat_id { "FR12345678901" }
    end
  end
end
