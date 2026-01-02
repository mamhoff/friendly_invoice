class InvoiceDocument
  def initialize(invoice)
    @invoice = invoice
  end

  def render
    doc = HexaPDF::Document.new

    configure_document(doc)
    build_pages(doc)

    doc
  end

  private

  def configure_document(doc)
    doc.trailer.info[:Title] = "Invoice #{@invoice.number}"
    doc.trailer.info[:Creator] = "YourApp"

    # For later: PDF/A-3
    # doc.config["pdfa.level"] = "3u"
  end

  def build_pages(doc)
    page = doc.pages.add
    canvas = page.canvas

    render_header(canvas)
    render_line_items(canvas)
    render_totals(canvas)
  end

  def render_header(canvas)
    canvas.font("Helvetica", size: 18)
    canvas.text("Invoice #{@invoice.number}", at: [50, 800])
  end

  def render_line_items(canvas)
    canvas.font("Helvetica", size: 10)
    y = 760

    @invoice.items.each do |item|
      canvas.text("#{item.description} — #{item.net_amount}", at: [50, y])
      y -= 14
    end
  end

  def render_totals(canvas)
    canvas.font("Helvetica", size: 12, variant: :bold)
    canvas.text("Total: #{@invoice.net_amount}", at: [50, 100])
  end
end
