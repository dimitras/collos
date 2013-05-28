class ContactsController < ApplicationController

    def new
        @contact = Contact.new(user: User.find(params[:user_id]))
    end
end
