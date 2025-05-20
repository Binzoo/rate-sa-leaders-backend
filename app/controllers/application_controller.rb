class ApplicationController < ActionController::API
  include JwtAuthenticable

  private
  
  def json_request?
    request.format.json?
  end
end
