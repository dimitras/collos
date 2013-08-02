class AddressesController < ApplicationController
    load_and_authorize_resource
    def index
        @addresses = @addresses.page(params[:page] || 1)
    end
    def show; end

    def new;  end

    def create
        if user_id = params.delete(:user_id)
            @user = User.find(user_id)
        end
        if @address.save
            if @user
                @address.users << @user
                redirect_to @address, notice: "Address created successfully and added to User"
            else
                redirect_to @address, notice: "Address created successfully"
            end
        else
            render action: 'new', params: params.merge(user_id: user_id)
        end
    end
    def edit; end
    def update
        if @address.update_attributes(params[:address])
            redirect_to @address, notice: "Address updated"
        else
            render action: 'edit'
        end
    end

    def destroy
        if @address.destroy
            redirect_to :back, notice: "Address destroyed"
        else
            redirect_to :back, error: "Something went wrong. Could not delete address"
        end
    end

    def assign
        @user = User.find(params[:user_id])
        @address.users << @user
        redirect_to :back, notice: "User added to address"
    end

    def remove
        @user = @address.users.find(params[:user_id])
        if @user
            if @address.users.delete(@user)
                flash[:success] = "User removed from address"
                redirect_to :back
            end
        end
    end
end
