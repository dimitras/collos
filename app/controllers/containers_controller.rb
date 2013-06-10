class ContainersController < ApplicationController
    load_and_authorize_resource
    autocomplete :container_type, :name, display_value: :pretty_string, full: true

    def index
        @containers = @containers.includes(:container_type => [ :type ] ).page(params[:page])
    end
    def show
        @container = Container.includes(:container_type => [ :type ] ).find(@container)
    end
    def new; end
    def create
        @container.parent = nil
        if @container.save
            redirect_to container_path(@container), :success => "Container successfully created"
        else
            flash[:error] = @container.errors.to_yaml
            render :action => 'new'
        end
    end
    def edit
        @container = Container.includes(:barcode, :container_type).find(@container)
    end
    def update
        if @container.update_attributes(params[:container])
            flash[:success] = "ContainerType successfully updated."
            redirect_to @container
        else
            render action: 'edit'
        end
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
