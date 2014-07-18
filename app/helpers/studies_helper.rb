module StudiesHelper

	def labels
		require 'prawn'
		if @study.samples
			# pdf = Prawn::Document.new
			Prawn::Document.generate("app/assets/images/labels/#{@study.id}.pdf") do |pdf|
				pdf.font_size(8)
				@study.samples.each do |sample|
					sample.barcode.create_img
					pdf.image "app/assets/images/qr_codes/#{sample.barcode.to_s}.png"
					pdf.text sample.barcode.to_s
		            pdf.text "PENTACON-#{@study.id}"
		            pdf.text sample.source_name
		            pdf.text sample.treatments
	    		end
	    	end
        end
	end

end
