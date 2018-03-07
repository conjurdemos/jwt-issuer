class ApplicationController < ActionController::API
  class NotFoundError < RuntimeError
  end

  rescue_from NotFoundError, with: :not_found_error

  def not_found_error e
    logger.warn(e)
    head :not_found
  end
end
