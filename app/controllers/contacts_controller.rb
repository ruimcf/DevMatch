class ContactsController < ApplicationController
  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end

  # POST request to /contacts
  def create
    # mass assigment of form field into contact object
    @contact = Contact.new(contact_params)
    # save the contact object to the database
    if @contact.save
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Execute the contact_email method inside the ContactMailer class, and deliver the email
      ContactMailer.contact_email(name, email, body).deliver
      # Store the success flash message
      flash[:success] = "Message sent."
      # Redirect the user to the new contact page
      redirect_to new_contact_path
    else
      # If an error occurs while saving the contact on the database
      # For example incomplete parameters
      # Store the error in the flash message
      # And redirect the user to the new contact page
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end


  private
    # To collect data from form, we need to use
    # Strong parameters and whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end
