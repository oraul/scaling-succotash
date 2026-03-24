# frozen_string_literal: true

require 'console'

module AppLogger
  SUBJECT = 'app'

  def self.info(event, context = {})
    Console.logger.info(SUBJECT, context.merge(event: event))
  end

  def self.warn(event, context = {})
    Console.logger.warn(SUBJECT, context.merge(event: event))
  end

  def self.error(event, context = {})
    Console.logger.error(SUBJECT, context.merge(event: event))
  end

  def self.debug(event, context = {})
    Console.logger.debug(SUBJECT, context.merge(event: event))
  end
end
