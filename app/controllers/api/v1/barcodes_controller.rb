class Api::V1::BarcodesController < BaseController
    load_and_authorize_resource
    respond_to :json
    @@per_page =100

    def index
        @barcodes = @barcodes.includes(:barcodeable).page(params[:page] || 1).per_page(100)
    end
end
