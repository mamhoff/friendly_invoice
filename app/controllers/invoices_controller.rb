require "zip"

class InvoicesController < CommonsController
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    # put an empty item
    @invoice.items << Item.new(common: @invoice, taxes: Tax.default)
    render
  end

  # GET /invoices/autocomplete.json
  # View to get the item autocomplete feature.
  def autocomplete
    @items = Item.autocomplete_by_description(params[:term])
    respond_to do |format|
      format.json
    end
  end

  def send_email
    @invoice = Invoice.find(params[:id])
    begin
      @invoice.send_email
      redirect_back(fallback_location: root_path, notice: "Email successfully sent.")
    rescue Exception => e
      redirect_back(fallback_location: root_path, alert: e.message)
    end
  end

  # Renders a common's template in html and pdf formats
  def print
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.pdf do
        send_data(
          @invoice.pdf,
          filename: "#{@invoice}.pdf",
          disposition: "inline"
        )
      end
    end
  end

  # Bulk actions for the invoices listing
  def bulk
    ids = params["#{model.name.underscore}_ids"]
    if ids.is_a?(Array) && ids.length > 0
      invoices = Invoice.where(id: params["#{model.name.underscore}_ids"])
      case params["bulk_action"]
      when "send_email"
        begin
          invoices.each { |inv| inv.send_email }
          flash[:info] = "Successfully sent #{ids.length} emails."
        rescue Exception => e
          flash[:alert] = e.message
        end
      when "set_paid"
        total = invoices.inject(0) do |n, inv|
          inv.set_paid! ? n + 1 : n
        end
        flash[:info] = "Successfully set as paid #{total} invoices."
      when "pdf"
        send_data(
          zip_hexapdfs(invoices),
          filename: "invoices.zip",
          type: "application/zip",
          disposition: "attachment"
        )
        return
      when "duplicate"
        invoices.each do |inv|
          inv.duplicate
        end
        flash[:info] = "Successfully copy #{invoices.length} invoices."
      else
        flash[:info] = "Unknown action."
      end
    end
    redirect_to action: :index
  end

  protected

  def set_listing(instances)
    @invoices = instances
  end

  def set_instance(instance)
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def invoice_params
    common_params + [
      :number,
      :issue_date,
      :due_date,

      :email_template_id,
      :print_template_id,

      :failed,

      payments_attributes: [
        :id,
        :date,
        :amount,
        :notes,
        :_destroy
      ]
    ]
  end

  def zip_hexapdfs(invoices)
    Zip::OutputStream.write_buffer do |zip|
      invoices.each do |invoice|
        zip.put_next_entry("#{invoice}.pdf")
        zip.write(invoice.pdf)
      end
    end.string
  end
end
