class BarcodesController < ApplicationController
  def index
    @barcodes = Barcode.paginate(page: params[:page])
  end

  def show
    @barcode = Barcode.find(params[:id])
  end

  def new
    redirect_to :create
  end

  def create
    @barcode = Barcode.generate_barcodes(1)[0]
    redirect_to @barcode
  end

  # Generates a set of barcodes for consumption
  def generate
    @barcode_set_id , @barcodes = Barcode.generate_barcodes(n.to_i)
    # render "barcodes"
    respond_to do |format|
      format.html
      format.csv {render "barcodes", content_type: "text/csv", filename: "barcodes_#{@barcode_set_id}.csv"}
      format.json {render "barcodes", content_type: "text/json", filename: "barcodes_#{@barcode_set_id}.json"}
      format.xml {render "barcodes", content_type: "text/xml", filename: "barcodes_#{@barcode_set_id}.xml"}
    end
  end

  def fetch
    @barcode_set_id = params[:barcode_set].to_i
    @barcodes = Barcode.where(:barcode_set => @barcode_set_id).paginate(params[:page] || 1)
    if @barcodes.empty?
      redirect_to barcode_path, alert: "Invalid Barcode Set ID \"#{@barcode_set_id}\""
    else
      respond_to do |format|
        format.html {render "barcodes"}
        format.csv {render "barcodes", content_type: "text/csv", filename: "barcode_#{@barcodes_set_id}.csv"}
        format.json {render "barcodes", content_type: "text/json", filename: "barcode_#{@barcodes_set_id}.json"}
        format.xml {render "barcodes", content_type: "text/xml", filename: "barcode_#{@barcodes_set_id}.xml"}
      end
    end
  end
end
