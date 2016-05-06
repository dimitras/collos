module StudiesHelper

	def labels
		require 'prawn'
		if @study.samples
			Prawn::Document.generate("app/assets/images/labels/#{@study.id}.pdf", :page_layout => :landscape, :print_scaling => :none) do |pdf|
				
				samples_list = @study.samples
				container_types=[]
				samples_list.each do |sample|
					if !samples_list.nil? && sample.container
						container_types << sample.container.container_type.name
					end
				end
				container_types = container_types.uniq{|type| type}
				# pdf.text container_types.inspect

				container_types.each do |type|
					if type.eql?("2 mL tube")
						# pdf.text type.inspect
						pdf.font_size(4)
						pdf.define_grid(:columns => 18, :rows => 8, :gutter => 3)
						qcode_scale = 0.5
					elsif type.eql?("0.5 mL tube")
						pdf.font_size(3)
						pdf.define_grid(:columns => 20, :rows => 10, :gutter => 3)
						qcode_scale = 0.4
					elsif type.eql?("15 mL tube")
						pdf.font_size(5)
						pdf.define_grid(:columns => 15, :rows => 6, :gutter => 3)
						qcode_scale = 0.5
					else
						break
					end
					
					all_rows = @study.samples.size/pdf.grid.columns
					
					pagenumber = 1
					for i in 0..all_rows-1
						if i > pdf.grid.rows-1 && pagenumber == 1
							pagenumber = 2
							pdf.start_new_page
						end
						for j in 0..pdf.grid.columns-1
							pdf.grid(i.to_i,j.to_i).bounding_box do
								if !samples_list.empty?
									sample = samples_list.pop
									sample.barcode.create_img
									pdf.image "app/assets/images/qr_codes/#{sample.barcode.to_s}.png", :scale => qcode_scale
									pdf.text "#{sample.barcode.to_s}"
									pdf.text_box("PENTACON-#{@study.id}\n#{sample.source_name}\n#{sample.treatments}", :rotate => 90)
								end
							end
						end
					end

					# pdf.grid.show_all
					pdf.encrypt_document(:permissions => { :print_document => true })
				end
	    	end
        end
	end

end
