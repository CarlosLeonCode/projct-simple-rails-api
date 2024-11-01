# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    if resource&.valid_password?(params[:user][:password])
      sign_in(resource_name, resource)
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: ActiveModelSerializers::SerializableResource.new(resource).as_json,
        token: resource.generate_jwt
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      sign_out
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Couldn't find an active session." }
      }, status: :unauthorized
    end
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end
end

