class Api::V1::FetchController < ApplicationController
  def show
    render json: Fetch.new(params[:prefix], params[:name], options).do
  rescue Fetch::InvalidOptions => e
    render json: { errors: e.message }, status: :unprocessable_entity
  rescue Fetch::UnknownClass => e
    render json: { errors: e.message }, status: :not_found
  end

  private

  def options
    params.except(:controller, :action, :name, :prefix)
  end
end
