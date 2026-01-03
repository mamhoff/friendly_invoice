require "rails_helper"

RSpec.describe TradePartnersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/trade_partners").to route_to("trade_partners#index")
    end

    it "routes to #new" do
      expect(get: "/trade_partners/new").to route_to("trade_partners#new")
    end

    it "routes to #show" do
      expect(get: "/trade_partners/1").to route_to("trade_partners#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/trade_partners/1/edit").to route_to("trade_partners#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/trade_partners").to route_to("trade_partners#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/trade_partners/1").to route_to("trade_partners#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/trade_partners/1").to route_to("trade_partners#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/trade_partners/1").to route_to("trade_partners#destroy", id: "1")
    end
  end
end
