# Error module to handle errors globally
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      end
    end

    private
    def record_not_found(_e)
      respond_to do |format|
        format.html { redirect_to root_path, alert: _e.message }
      end
    end
  end
end
