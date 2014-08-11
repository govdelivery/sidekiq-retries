module Sidekiq
  module Retries
    class RetryError < StandardError
      attr_accessor :cause

      def initialize(cause, msg=nil)
        super(msg)
        self.cause=cause
      end
    end

    class Retry < RetryError
      attr_accessor :max_retries, :delay

      def initialize(cause, max_retries=nil, msg=nil, delay=nil)
        super(cause, msg)
        self.max_retries = max_retries
        self.delay = delay
      end
    end

    class Fail < RetryError
    end

  end
end
