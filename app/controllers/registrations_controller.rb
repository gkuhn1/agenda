class RegistrationsController < Devise::RegistrationsController

  private

    def sign_up(resource_name, resource)
      super
      account = Account.new(name: resource.name)
      account.add_user(resource)
      account.save
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password, :password_confirmation)
      end
    end

end