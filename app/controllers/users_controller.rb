class UsersController < ApplicationController
    load_and_authorize_resource
    @@per_page = 25

    def index
        if params[:show_all]
            @user = @user.unscoped
        end
        @users = @users.page(params[:page] || 1).per_page(params[:per_page] || @@per_page)
    end
    def show
        @addresses = @user.addresses
    end

    # Regular edit functionality. If current_user.admin? then you can change
    # the active/inactive status of the supplied user
    def edit
        @addresses = @user.addresses
    end
    def update
        if @user.update_attributes(params[:user])
            redirect_to @user, notice: "User was successfully updated"
        else
            render action: "edit"
        end
    end

    def new; end
    def create
        if @user.save
            UserRegistrationMailer.delay.welcome(@user.id)
            # don't use sidekiq
            # UserRegistrationMailer.welcome(@user.id)
            redirect_to @user, notice: 'Successfully registered.'
        else
            render action: "new"
        end
    end

    def destroy
        redirect_to user_deactivate_path(@user)
    end

    def activate
        @user = User.find(params[:id])
        @user.active!
        flash[:success] = "User #{@user.name} now active"
        redirect_to user_path(@user)
    end

    def deactivate
        @user.inactive!
        @user.save
        flash[:success]= "User #{@user.name} now deactivated"
        redirect_to @user
    end
end
