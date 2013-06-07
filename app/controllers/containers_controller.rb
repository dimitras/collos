class ContainersController < ApplicationController
    load_and_authorize_resource
    autocomplete :container_type, :name, full: true

    def index
        @containers = @containers.includes(:container_type => [ :type ] ).page(params[:page])
    end
    def show
        @container.includes(:container_type => [ :type ] )
    end
    def new; end
    def create
    end
    def edit; end
    def update
    end

    def destroy
        begin
            @container.destroy
            flash[:success] = 'Container deleted'
            redirect_to containers_url
        rescue Exception => e
            flash[:error] = "Container was not deleted because #{e.message}"
            render @container
        end
    end
end
