module Admin
  module Api
    module V1
      class AdminsController < ApplicationController
        def login
          admin = AdminUser.find_by(email: params[:email])

          if admin&.authenticate(params[:password])
            token = generate_token(admin)
            render json: {
              token: token,
              admin: {
                id: admin.id,
                name: admin.name,
                email: admin.email
              }
            }, status: :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end

        private

        def generate_token(admin)
          payload = {
            admin_id: admin.id,
            exp: 5.hours.from_now.to_i
          }
          JWT.encode(payload, Rails.application.credentials.secret_key_base)
        end
      end
    end
  end
end
