# Sidekiq::Retries

This subclasses the stock Sidekiq retries middleware to give you some additional options to conditionally retry jobs
irrespective of whether retries are enabled for the job.

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-retries'

## Usage

    class MyWorker
      include Sidekiq::Worker
      sidekiq_options retry: false # or retry: 25, or the default...

      def perform
        #force a retry even if retry: false using default retry options
        raise Sidekiq::Retries::Retry.new(RuntimeError.new('whatever happened'))

        #force a retry even if retry: false using a specific max_retries
        raise Sidekiq::Retries::Retry.new(RuntimeError.new('whatever happened'), 10)

        #if e.g. retries: true or retries: 10, skip it anyway
        raise Sidekiq::Retries::Fail.new(RuntimeError.new('whatever happened'))

        #add delay option
        raise Sidekiq::Retries::Fail.new(RuntimeError.new('whatever happened'), nil, nil, 24.hours)
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

