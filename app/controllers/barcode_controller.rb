class BarcodeController < ApplicationController
  def index
  end

  # Generates a set of barcodes for consumption
  def generate
    n = params[:n].to_i
    if n < 1 
      redirect_to barcode_path, error: "Parameter N = #{} is less than 1" 
    end
    @barcodes = Barcode.generate_barcodes(n)
    @barcode_set_id = @barcodes.first.barcode_set
    render "barcodes"    
    # respond_to do |format|
    #   format.html
    #   format.json
    #   format.xml
    #   format.csv
    # end
  end

  def fetch
    bc_set = params[:sid]
    @barcodes = Barcode.where(:barcode_set => bc_set).all
    @barcode_set_id = @barcodes.first.barcode_set
    if @barcodes.empty?
      redirect_to barcode_path, alert: "Invalid Barcode Set ID \"#{bc_set}\""
    else
      respond_to do |format|
        format.html {render "barcodes"}
        format.csv {render "barcodes", content_type: "text/csv", filename: "barcode_#{@barcode_set_id}.csv"}
        format.json {render "barcodes", content_type: "text/json", filename: "barcode_#{@barcode_set_id}.json"}
        format.xml {render "barcodes", content_type: "text/xml", filename: "barcode_#{@barcode_set_id}.xml"}
      end
    end
    # respond_to do |format|
    #   format.html render "barcode"
    # end
  end
end
