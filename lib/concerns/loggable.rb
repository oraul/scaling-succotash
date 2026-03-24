# frozen_string_literal: true

require_relative '../logger'

module Concerns
  module Loggable
    def log_info(event, context = {})
      AppLogger.info(event, context.merge(source: self.class.name))
    end

    def log_warn(event, context = {})
      AppLogger.warn(event, context.merge(source: self.class.name))
    end

    def log_error(event, context = {})
      AppLogger.error(event, context.merge(source: self.class.name))
    end

    def log_debug(event, context = {})
      AppLogger.debug(event, context.merge(source: self.class.name))
    end
  end
end
