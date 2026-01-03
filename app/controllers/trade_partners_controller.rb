class TradePartnersController < ApplicationController
  before_action :set_trade_partner, only: %i[ show edit update destroy ]

  # GET /trade_partners or /trade_partners.json
  def index
    @trade_partners = TradePartner.all
  end

  # GET /trade_partners/1 or /trade_partners/1.json
  def show
  end

  # GET /trade_partners/new
  def new
    @trade_partner = TradePartner.new
  end

  # GET /trade_partners/1/edit
  def edit
  end

  # POST /trade_partners or /trade_partners.json
  def create
    @trade_partner = TradePartner.new(trade_partner_params)

    respond_to do |format|
      if @trade_partner.save
        format.html { redirect_to trade_partners_path, notice: "Trade partner was successfully created." }
        format.json { render :show, status: :created, location: @trade_partner }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @trade_partner.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /trade_partners/1 or /trade_partners/1.json
  def update
    respond_to do |format|
      if @trade_partner.update(trade_partner_params)
        format.html { redirect_to trade_partners_path, notice: "Trade partner was successfully updated." }
        format.json { render :show, status: :ok, location: @trade_partner }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @trade_partner.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /trade_partners/1 or /trade_partners/1.json
  def destroy
    @trade_partner.destroy!

    respond_to do |format|
      format.html { redirect_to trade_partners_path, status: :see_other, notice: "Trade partner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trade_partner
    @trade_partner = TradePartner.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trade_partner_params
    params.require(:trade_partner).permit(:name, :legal_name, :street, :address_line_2, :city, :postal_code, :country_code, :vat_id, :tax_id, :global_id, :global_id_scheme, :email, :phone)
  end
end
