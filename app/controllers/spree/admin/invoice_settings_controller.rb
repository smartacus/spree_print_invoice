module Spree
  module Admin
    class InvoiceSettingsController < Admin::BaseController
      def update
        Spree::PrintInvoice::Config[:print_invoice_next_number] = params[:print_invoice_next_number]
        Spree::PrintInvoice::Config[:print_invoice_font_face] = params[:print_invoice_font_face]
        Spree::PrintInvoice::Config[:print_invoice_logo_scale] = params[:print_invoice_logo_scale]
        Spree::PrintInvoice::Config[:print_invoice_barcode_enabled] = params[:print_invoice_barcode_enabled] == 'enabled'
        Spree::PrintInvoice::Config[:print_invoice_barcode_justification] = params[:print_invoice_barcode_justification]
        Spree::PrintInvoice::Config[:print_invoice_barcode_vertical_offset] = params[:print_invoice_barcode_vertical_offset]

        flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:invoice_settings))

        render :edit
      end
    end
  end
end
