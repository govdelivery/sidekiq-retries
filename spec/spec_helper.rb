begin
  require 'pry'
rescue LoadError
end

require 'rspec'

require 'sidekiq'
require 'sidekiq/retries'
require 'sidekiq/cli'
Sidekiq.logger.level = Logger::ERROR

require 'sidekiq/redis_connection'
redis_url = ENV['REDIS_URL'] || 'redis://localhost/15'
REDIS = Sidekiq::RedisConnection.create(:url => redis_url, :namespace => 'sidekiq_retries')

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }
