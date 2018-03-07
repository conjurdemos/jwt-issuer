class JwkController < ApplicationController
  def get
    jwk = JWK.new params[:kid]
    raise ApplicationController::NotFoundError if jwk.empty?
    render json: jwk.to_h
  end
end
