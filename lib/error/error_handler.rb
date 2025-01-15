# Error module to handle errors globally
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :respond
        rescue_from StandardError, with: :respond
        # TODO: Using StandardError makes it difficult to provide specific messages.
      end
    end

    private
    def respond(_e)
      respond_to do |format|
        format.html { redirect_to root_path, alert: _e.message }
      end
    end
  end
end
