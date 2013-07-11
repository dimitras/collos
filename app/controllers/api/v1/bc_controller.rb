class Api::V1::BcController < Api::V1::BaseController
    # load_and_authorize_resource :barcode

    def index
        @barcodes = Barcode.includes(:barcodeable).page(params[:page] || 1).per_page(100)
        authorize! :read, @barcodes
    end
end
