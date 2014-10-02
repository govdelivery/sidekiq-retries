require 'celluloid'
require 'sidekiq/middleware/server/retry_jobs'

module Sidekiq
  module Retries
    module Server
      class Middleware < Sidekiq::Middleware::Server::RetryJobs

        def call(worker, msg, queue)
          yield
        rescue Sidekiq::Shutdown
          # ignore, will be pushed back onto queue during hard_shutdown
          raise
        rescue Sidekiq::Retries::Retry => e
          # force a retry (for workers that have retries disabled)
          msg['retry'] ||= e.max_retries
          attempt_retry(worker, msg, queue, e.cause, e.delay)
          raise e.cause
        rescue Sidekiq::Retries::Fail => e
          # don't retry this message (for workers that retry by default)
          raise e.cause
        rescue Exception => e
          attempt_retry(worker, msg, queue, e) if msg['retry']
          raise e
        end

        private

        # This is the default Sidekiq 3.2.2x retry logic
        def attempt_retry(worker, msg, queue, e, delay=nil)
          max_retry_attempts = retry_attempts_from(msg['retry'], @max_retries)

          msg['queue'] = if msg['retry_queue']
                           msg['retry_queue']
                         else
                           queue
                         end
          msg['error_message'] = e.message[0..10_000]
          msg['error_class'] = e.class.name
          count = if msg['retry_count']
                    msg['retried_at'] = Time.now.to_f
                    msg['retry_count'] += 1
                  else
                    msg['failed_at'] = Time.now.to_f
                    msg['retry_count'] = 0
                  end

          if msg['backtrace'] == true
            msg['error_backtrace'] = e.backtrace
          elsif msg['backtrace'] == false
            # do nothing
          elsif msg['backtrace'].to_i != 0
            msg['error_backtrace'] = e.backtrace[0..msg['backtrace'].to_i]
          end

          if count < max_retry_attempts
            delay ||= delay_for(worker, count)
            logger.debug { "Failure! Retry #{count} in #{delay} seconds" }
            retry_at = Time.now.to_f + delay
            payload = Sidekiq.dump_json(msg)
            Sidekiq.redis do |conn|
              conn.zadd('retry', retry_at.to_s, payload)
            end
          else
            # Goodbye dear message, you (re)tried your best I'm sure.
            retries_exhausted(worker, msg)
          end
        end

      end
    end
  end
end
