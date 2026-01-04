class InvoiceDocument
  STYLES = {
    base: {font: "Lato", font_size: 10, line_spacing: 1.3},
    top: {font_size: 8},
    top_box: {padding: [90, 0, 0], margin: [0, 0, 10], border: {width: [0, 0, 1]}},
    header: {font: "Lato bold", font_size: 20, margin: [50, 0, 20]},
    line_items: {border: {width: 1, color: "eee"}, margin: [20, 0]},
    line_item_cell: {font_size: 8},
    footer: {border: {width: [1, 0, 0], color: "darkgrey"}, padding: [5, 0, 0],
             valign: :bottom},
    footer_heading: {font: "Lato bold", font_size: 8, padding: [0, 0, 8]},
    footer_text: {font_size: 8, fill_color: "darkgrey"}
  }

  attr_reader :invoice, :settings, :composer

  def initialize(invoice)
    @invoice = invoice
    @settings = Settings
    @composer = HexaPDF::Composer.new
  end

  def render
    configure
    compose_document

    composer.document
  end

  private

  def configure
    composer.document.task(:pdfa)
    composer.styles(**STYLES)
    composer.document.tap do |doc|
      doc.trailer.info[:Title] = "Invoice #{@invoice}"
      doc.trailer.info[:Creator] = "YourApp"
      doc.config["font.map"] = {
        "Lato" => {
          none: Rails.root.join("app", "fonts", "Lato-Regular.ttf"),
          bold: Rails.root.join("app", "fonts", "Lato-Bold.ttf"),
          italic: Rails.root.join("app", "fonts", "Lato-Italic.ttf"),
          bold_italic: Rails.root.join("app", "fonts", "Lato-BoldItalic.ttf")
        }
      }
    end
  end

  def compose_document
    render_sender
    render_header_columns
    render_hello
    render_line_items
    render_footer
  end

  def render_sender
    composer.box(:container, style: :top_box) do |container|
      container.formatted_text([
        {text: invoice.seller.name, font: "Lato bold"},
        "\n",
        invoice.seller.address.join(" - ")
      ], style: :top)
    end
  end

  def render_meta(layout)
    cells = [["Invoice number:", invoice.to_s],
      ["Invoice date", invoice.issue_date],
      ["Start date:", invoice.starting_date],
      ["Finishing date:", invoice.finishing_date]]
    layout.table(cells, column_widths: [150, 80], align: :right) do |args|
      args[] = {cell: {border: {width: 0}, padding: [0, 0, 4, 4]}, text_align: :right}
      args[0..-1, 0] = {font: "Lato bold"}
    end
  end

  def render_recipient(layout)
    layout.formatted_text([
      invoice.name,
      "\n",
      invoice.invoicing_address
    ].compact)
  end

  def render_header_columns
    layout = composer.document.layout
    cells = [[render_recipient(layout), render_meta(layout)]]
    composer.table(cells) do |args|
      args[] = {cell: {border: {width: 0}, padding: 0, margin: 0}}
      args[1, 0] = {cell: {text_align: :right}}
    end
  end

  def render_hello
    composer.text("Invoice - #{invoice}", style: :header)
    composer.text("Thank you for your order. Following are the items you purchased:")
  end

  def render_line_items
    cells = [["Description", "Price", "Amount", "Total"]]
    invoice.items.each do |item|
      cells << [item.description, item.unitary_cost, item_taxes(item), item.net_amount]
    end
    invoice.taxes.each do |name, amount|
      cells << [nil, nil, name, amount]
    end
    cells << [nil, nil, "Total", invoice.gross_amount]
    composer.table(cells, column_widths: [250, 80], style: :line_items) do |args|
      args[] = {cell: {border: {width: 0}, padding: 8}, style: :line_item_cell}
      args[0] = {cell: {background_color: "eee"}, font: "Lato bold"}
      args[-3] = {cell: {border: {width: [1, 0, 0]}},
                  font: "Lato bold"}
      args[-2] = {font: "Lato bold"}
      args[-1] = {cell: {background_color: "eee", border: {width: [1, 0, 0]}}, font: "Lato bold"}
      args[0..-1, 1..-1] = {text_align: :right}
    end
  end

  def item_taxes(item)
    item.taxes_hash.map do |tax, amount|
      "#{tax.name}: #{amount}"
    end.join("\n")
  end

  def render_footer
    composer.text("Please transfer the total amount via SEPA transfer to the bank " \
                "account below immediately after receiving the invoice - thank you.")

    l = composer.document.layout
    cells = [
      [
        l.text(invoice.seller.legal_name, style: :footer_heading),
        l.text(invoice.seller.street, style: :footer_text),
        invoice.seller.address_line_2 && l.text(invoice.seller.address_line_2, style: :footer_text),
        l.text(invoice.seller.address_line_3, style: :footer_text)
      ].compact,
      [l.text("Contact", style: :footer_heading),
        l.text("owner@samplecorp.com\nOwner: Me, Myself, And I", style: :footer_text)],
      [l.text("Bank Account", style: :footer_heading),
        l.text("Sample Corp Bank\nIBAN: SC01 2345 6789 0123 4567\nBIC: SACOZZB123",
          style: :footer_text)]
    ]
    composer.table([cells], cell_style: {border: {width: 0}}, style: :footer)
  end
end
