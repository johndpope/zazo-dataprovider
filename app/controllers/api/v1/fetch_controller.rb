class Api::V1::FetchController < ApplicationController
  def show
    render json: Fetch.new(params[:entity], params[:prefix], params[:name], options).do
  rescue Fetch::InvalidOptions => e
    render json: { errors: e.errors }, status: :unprocessable_entity
  rescue Fetch::UnknownClass => e
    render json: { errors: e.message }, status: :not_found
  end

  private

  def options
    params.except(:controller, :action, :entity, :prefix, :name)
  end
end
