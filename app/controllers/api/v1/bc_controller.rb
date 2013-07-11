class Api::V1::BcController < Api::V1::BaseController
    load_and_authorize_resource class: "Barcode"

    respond_to :json

    def index
        @barcodes = Barcode.includes(:barcodeable).page(params[:page] || 1).per_page(100)
        authorize! :read, @barcodes
    end

    def show
        @barcode = Barcode.find(params[:id]).includes(:barcodeable)
    end

    def update
    end

    def create
    end

    def generate
        authorize! :create, Barcode
        if params[:num].to_i < 1
            head :bad_request
        end

        barcode_set_id = nil
        if params[:barcode_set].to_i > 0
            barcode_set_id = params[:barcode_set].to_i
        end
        barcode_set_id, barcodes = Barcode.generate_barcodes(params[:num].to_i, barcode_set_id)
        head :created, location: fetch_api_bc_index_url(params: {barcode_set: barcode_set_id})
    end

    def fetch
        if params.has_key?(:barcode_set)
            @barcodes = Barcode.where(barcode_set: params[:barcode_set]).includes(:barcodeable).page(params[:page] || 1).per_page(100)
        else
            head :bad_request
        end
    end

end
