require 'sidekiq/job_retry'

module Sidekiq
  module Retries
    module Server
      class Middleware < Sidekiq::JobRetry

        def call(worker, msg, queue)
          yield
        rescue Sidekiq::Shutdown
          # ignore, will be pushed back onto queue during hard_shutdown
          raise
        rescue Sidekiq::Retries::Retry => e
          # force a retry (for workers that have retries disabled)
          msg['retry'] = e.max_retries
          attempt_retry(worker, msg, queue, e.cause)
          raise e.cause
        rescue Sidekiq::Retries::Fail => e
          # seriously, don't retry this
          raise e.cause
        rescue Exception => e
          # ignore, will be pushed back onto queue during hard_shutdown
          raise Sidekiq::Shutdown if exception_caused_by_shutdown?(e)
          raise e unless msg['retry']
          attempt_retry(worker, msg, queue, e)
          raise e
        end

      end
    end
  end
end
