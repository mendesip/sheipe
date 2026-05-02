module Api
  module V1
    class BaseController < ApplicationController
      include ActionPolicy::Controller

      authorize :user, through: :current_user

      DEFAULT_PER_PAGE = 25
      MAX_PER_PAGE = 100

      before_action :authenticate
      skip_before_action :authenticate, only: [ :not_found ]

      def current_user
        Current.user
      end

      rescue_from StandardError,                        with: :render_internal_error
      rescue_from ActionPolicy::Unauthorized,           with: :render_forbidden
      rescue_from ActiveRecord::RecordInvalid,          with: :render_validation_failed
      rescue_from ActionController::ParameterMissing,   with: :render_bad_request
      rescue_from ActiveRecord::RecordNotFound,         with: :render_not_found
      rescue_from ArgumentError,                        with: :render_argument_error

      def not_found
        render_error("not_found", "Not found", nil, :not_found)
      end

      private

      def paginate(scope)
        page = [ params[:page].to_i, 1 ].max
        per  = (params[:per_page].presence || DEFAULT_PER_PAGE).to_i.clamp(1, MAX_PER_PAGE)
        total = scope.count
        records = scope.offset((page - 1) * per).limit(per)
        meta = {
          current_page: page,
          total_pages:  (total.to_f / per).ceil,
          total_count:  total,
          per_page:     per
        }
        [ records, meta ]
      end

      def authenticate
        token = request.headers["Authorization"]&.delete_prefix("Bearer ")&.strip
        session = token.present? ? Session.find_by(access_token: token) : nil

        if session.nil? || session.access_token_expires_at < Time.current
          render_error("unauthorized", "Unauthorized", nil, :unauthorized)
        else
          Current.session = session
        end
      end

      def render_not_found(_e)
        render_error("not_found", "Record not found", nil, :not_found)
      end

      def render_bad_request(e)
        render_error("bad_request", e.message, nil, :bad_request)
      end

      def render_validation_failed(e)
        details = e.record.errors.to_hash
        render_error("validation_failed", "Validation failed", details, :unprocessable_entity)
      end

      def render_argument_error(e)
        render_error("validation_failed", e.message, nil, :unprocessable_entity)
      end

      def render_forbidden(_e)
        render_error("forbidden", "Forbidden", nil, :forbidden)
      end

      def render_internal_error(e)
        Rails.logger.error("#{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}")
        render_error("internal_error", "Internal server error", nil, :internal_server_error)
      end

      def render_error(code, message, details, status)
        render json: { error: { code: code, message: message, details: details } }, status: status
      end
    end
  end
end
