class ErrorsController < ApplicationController
  def not_found
    render json: { errors: "invalid route: #{params[:not_found]}" }, status: :not_found
  end
end
