class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def route_not_found
    render json: { message: 'Route not found' }, status: :not_found
  end

  private

  def record_not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end

  def parameter_missing(exception)
    render json: { message: "Parameter missing: #{exception.param}" }, status: :unprocessable_entity
  end

  def render_json(resource, status = :ok, sanitize = false)
    to_exclude = sanitize ? [:created_at, :updated_at, :id, :player_id] : [:created_at, :updated_at]
    options = { include: { player_skills: { except: to_exclude } }, except: to_exclude }
    render json: resource, **options, status: status
  end
end
