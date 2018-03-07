class JwtController < ApplicationController
  def get
    token = Token.new params.except(:action, :controller)
    render json: token.jwt
  end
end