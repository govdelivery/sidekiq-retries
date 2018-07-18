require "sidekiq/retries/version"
require 'sidekiq/retries/server/middleware'
require 'sidekiq/retries/errors'

Sidekiq.configure_server do |config|
  require 'sidekiq/job_retry'
  require 'sidekiq/retries/server/middleware'

  stock_middleware = Sidekiq::JobRetry

  config.server_middleware do |chain|
    chain.add Sidekiq::Retries::Server::Middleware
    chain.remove stock_middleware
  end
end
