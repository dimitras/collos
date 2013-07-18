class ShipmentsController < ApplicationController
    load_and_authorize_resource
    def index
        @shipments = @shipments.includes({:containers => :samples})
        if params.has_key? :open
           @shipments = @shipments.where("ship_date <= ? and recieve_date is NULL",  Time.now())
        end
    end
    def show
        @shipment.containers
    end
    def new; end
    def create
    end
    def edit; end
    def update
    end
    def receive
        if @shipment.received!
            ShipmentMailer.delay.received(@shipment.id)
            redirect_to shipment_path(@shipment), notice: "Shipment marked as received. A e-mail has been sent to the sender."
        else
            redirect_to shipment_path(@shipment), error: "There was an error with our system. Please try again."
        end
    end

    def ship
        if @shipment.shipped!
            ShipmentMailer.delay.shipped(@shipment.id)
            redirect_to shipment_path(@shipment), notice: "Shipment marked as sent. A e-mail has been sent to the receiver."
        else
            redirect_to shipment_path(@shipment), error: "There was an error with our system. Please try again."
        end
    end

end
