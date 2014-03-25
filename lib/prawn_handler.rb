require 'prawn'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

module ActionView
  module Template::Handlers
    class Prawn 
      def self.register!
        Template.register_template_handler :prawn, self
      end
            
      def self.call(template)
        %(extend #{DocumentProxy}; #{template.source}; pdf.render)
      end
      
      module DocumentProxy
        def pdf
          unless @pdf
            @pdf = ::Prawn::Document.new
            add_barcode if Spree::PrintInvoice::Config[:print_invoice_barcode_enabled]
          end

          @pdf 
        end

        def outputter
          @outputter ||= Barby::PrawnOutputter.new(Barby::Code128B.new(barcode_data))
        end

        def barcode_data
          if Spree::PrintInvoice::Config.use_sequential_number? && @order.invoice_number.present?
            @order.invoice_number
          else
            @order.number
          end
        end

        def add_barcode
          outputter.annotate_pdf(pdf, { x: barcode_x, y: barcode_y })
        end

        def barcode_x
          case Spree::PrintInvoice::Config[:print_invoice_barcode_justification]
          when "left"
            pdf.bounds.left
          when "center"
            pdf.bounds.width / 2 - outputter.width / 2
          when "right"
            pdf.bounds.right - outputter.width
          end
        end

        def barcode_y
          pdf.bounds.top - Spree::PrintInvoice::Config[:print_invoice_barcode_vertical_offset]
        end

      private
      
        def method_missing(method, *args, &block)
          pdf.respond_to?(method) ? pdf.send(method, *args, &block) : super
        end
      end
    end
  end
end

ActionView::Template::Handlers::Prawn.register!
