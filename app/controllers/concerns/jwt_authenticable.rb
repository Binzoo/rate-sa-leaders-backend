module JwtAuthenticable
  extend ActiveSupport::Concern
  
  def authenticate_admin!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      decoded = JWT.decode(header, Rails.application.credentials.secret_key_base)[0]
      @current_admin = Admin.find(decoded['admin_id'])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
  
  def current_admin
    @current_admin
  end
end