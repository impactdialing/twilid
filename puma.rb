threads 0,16
workers 5
preload_app!
port ENV['PORT'] || 3000
rackup DefaultRackup
environment ENV['RACK_ENV'] || 'development'
