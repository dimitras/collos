class BarcodesController < ApplicationController
  def index
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
    if params[:num].to_i < 1
      redirect_to action: "index", alert: "Invalid number [#{params[:num]}] given." and return
    end
    barcode_set_id = nil
    if params[:barcode_set].to_i > 0
      barcode_set_id = params[:barcode_set].to_i
    end
    barcode_set_id, barcodes = Barcode.generate_barcodes(params[:num].to_i, barcode_set_id)
    redirect_to fetch_barcodes_path(barcode_set: barcode_set_id)
  end

  def fetch
    @barcode_set_id = params[:barcode_set].to_i
    @barcodes = Barcode.where(:barcode_set => @barcode_set_id).all
    if @barcodes.empty?
      flash[:error] ="Invalid Barcode Set ID \"#{@barcode_set_id}\""
      redirect_to barcodes_path
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
