class RecurringInvoicesController < CommonsController
  def generate
    # Generates pending invoices up to today
    RecurringInvoice.build_pending_invoices!
    redirect_to invoices_url
  end

  def index
    @any_invoices_to_be_built = RecurringInvoice.any_invoices_to_be_built?
    super
  end

  # GET /recurring_invoices/new
  def new
    @recurring_invoice = RecurringInvoice.new
    # put an empty item
    @recurring_invoice.items << Item.new(common: @recurring_invoice,
      taxes: Tax.default)
    render
  end

  # DELETE
  # bulk deletes selected elements on list
  def remove
    ids = params["#{model.name.underscore}_ids"]
    if ids.is_a?(Array) && ids.length > 0
      model.where(id: params["#{model.name.underscore}_ids"]).destroy_all
      flash[:info] = "Successfully deleted #{ids.length} #{type_label}"
    end
    redirect_to sti_path(@type)
  end

  protected

  def set_listing(instances)
    @recurring_invoices = instances
  end

  def set_instance(instance)
    @recurring_invoice = instance
  end

  def get_instance
    @recurring_invoice
  end

  def recurring_invoice_params
    common_params + [
      :enabled,
      :days_to_due,
      :starting_date,
      :finishing_date,
      :period,
      :period_type,
      :max_occurrences,
      :sent_by_email
    ]
  end
end
