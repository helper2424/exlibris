module Exlibris
  class Base
    class << self
      def logger
        defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      end
    end
  end
end