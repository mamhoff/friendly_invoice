require "rails_helper"

RSpec.describe TradePartiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/trade_parties").to route_to("trade_parties#index")
    end

    it "routes to #new" do
      expect(get: "/trade_parties/new").to route_to("trade_parties#new")
    end

    it "routes to #show" do
      expect(get: "/trade_parties/1").to route_to("trade_parties#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/trade_parties/1/edit").to route_to("trade_parties#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/trade_parties").to route_to("trade_parties#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/trade_parties/1").to route_to("trade_parties#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/trade_parties/1").to route_to("trade_parties#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/trade_parties/1").to route_to("trade_parties#destroy", id: "1")
    end
  end
end
