class ContactsController < ApplicationController
    load_and_authorize_resource
    def new
        @contact = Contact.new(user: User.find(params[:user_id]))
    end
end
