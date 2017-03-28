class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_sign_up_params
  before_filter :configure_update_params

  def new
    @token = params[:invite_token]
    super
  end

  def create
    @token = params[:invite_token]
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
  end

  def configure_update_params
    devise_parameter_sanitizer.for(:account_update) << :first_name << :last_name
  end

  def after_sign_up_path_for(resource)
    @token = params[:invite_token]
    if resource.is_a?(User) && @token
      redirect_to validate_path(:invite_token => @token)
    else
      super(resource)
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
