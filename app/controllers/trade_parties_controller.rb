class TradePartiesController < ApplicationController
  before_action :set_trade_party, only: %i[ show edit update destroy ]

  # GET /trade_parties or /trade_parties.json
  def index
    @trade_parties = TradeParty.all
  end

  # GET /trade_parties/1 or /trade_parties/1.json
  def show
  end

  # GET /trade_parties/new
  def new
    @trade_party = TradeParty.new
  end

  # GET /trade_parties/1/edit
  def edit
  end

  # POST /trade_parties or /trade_parties.json
  def create
    @trade_party = TradeParty.new(trade_party_params)

    respond_to do |format|
      if @trade_party.save
        format.html { redirect_to trade_parties_path, notice: "Trade partner was successfully created." }
        format.json { render :show, status: :created, location: @trade_party }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @trade_party.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /trade_parties/1 or /trade_parties/1.json
  def update
    respond_to do |format|
      if @trade_party.update(trade_party_params)
        format.html { redirect_to trade_parties_path, notice: "Trade partner was successfully updated." }
        format.json { render :show, status: :ok, location: @trade_party }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @trade_party.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /trade_parties/1 or /trade_parties/1.json
  def destroy
    @trade_party.destroy!

    respond_to do |format|
      format.html { redirect_to trade_parties_path, status: :see_other, notice: "Trade partner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trade_party
    @trade_party = TradeParty.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trade_party_params
    params.require(:trade_party).permit(:name, :legal_name, :street, :address_line_2, :city, :postal_code, :country_code, :vat_id, :tax_id, :global_id, :global_id_scheme, :email, :phone)
  end
end
