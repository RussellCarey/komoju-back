# https://github.com/heartcombo/devise/blob/main/app/controllers/devise_controller.rb
# https://github.com/heartcombo/devise/blob/main/app/controllers/devise/registrations_controller.rb
# Devise user defaults ["id", "email", "encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "created_at", "updated_at"]
class Users::RegistrationsController < Devise::RegistrationsController
  # Control what to send to views
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  # Disable devise session default on signup - own logic - need the user just created.
  def sign_up(resource_name, resource)
    @current_user = resource
  end

  def register_success
    # If the user selects they want to have mobile notifications too. Send one.
    unless @current_user.prefered_contact == 1
      Twillo::Message.send(
        "+817084771532", #@user.mobile_number
        "Thank you #{@current_user.email} for signing up for Tokeny. Your registration code is #{@current_user.reg_token}. Please login to activate."
      )
    end

    # Send signup email regardless of if the user wants to send SNS
    AuthMailer.with(user: @current_user, reg_token: @current_user.reg_token).signup_email.deliver_now

    render json: { message: "Signed up", user: @current_user }, status: :ok
  end

  def register_failed
    puts resource.errors.messages
    render json: { errors: resource.errors.messages }, status: 500
  end
end
