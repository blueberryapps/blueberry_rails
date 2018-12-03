workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 8)
threads Integer(threads_count / 2), threads_count

preload_app!

port        ENV.fetch('PORT') { 3000 }
environment ENV.fetch('RACK_ENV') { 'development' }

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
