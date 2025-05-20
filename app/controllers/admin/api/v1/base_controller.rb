module Admin
  module Api
    module V1
      class BaseController < ApplicationController
        before_action :authenticate_admin!

        private

        def authenticate_admin!
          header = request.headers['Authorization']
          token = header.split.last if header

          begin
            decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
            @current_admin = AdminUser.find(decoded["admin_id"])
          rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: "Unauthorized access" }, status: :unauthorized
          end
        end
      end
    end
  end
end
