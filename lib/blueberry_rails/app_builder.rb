module BlueberryRails
  class AppBuilder < Rails::AppBuilder

    include BlueberryRails::ActionHelpers

    def readme
      copy_file 'README.md', 'README.md'
    end

    def gitignore
      copy_file 'gitignore_custom', '.gitignore'
    end

    def gemfile
      template 'Gemfile_custom.erb', 'Gemfile'
    end

    def secret_token
      template 'secret_token.rb.erb', 'config/initializers/secret_token.rb'
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
    end

    def setup_mailer_hosts
      action_mailer_host 'development', "#{app_name}.dev"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
      after: /source 'https:\/\/rubygems.org'/
    end

    def use_postgres_config_template
      template 'database.yml.erb', 'config/database.yml',
        force: true
      template 'database.yml.erb', 'config/database.yml.sample'
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.slim', 'app/views/application/_flashes.html.slim'
    end

    def create_application_layout
      remove_file 'app/views/layouts/application.html.erb'
      copy_file 'layout.html.slim', 'app/views/layouts/application.html.slim'
    end

    def create_pryrc
      copy_file 'pryrc.rb', '.pryrc'
    end

    def remove_turbolinks
      replace_in_file 'app/assets/javascripts/application.js',
        /\/\/= require turbolinks\n/,
        ''
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def configure_rspec
      copy_file 'spec_helper.rb', 'spec/spec_helper.rb', force: true
    end

    def test_factories_first
      copy_file 'factories_spec.rb', 'spec/models/factories_spec.rb'
    end

    def setup_rspec_support_files
      copy_file 'factory_girl_syntax.rb', 'spec/support/factory_girl.rb'
      copy_file 'database_cleaner_setup.rb', 'spec/support/database_cleaner.rb'
    end

    def init_guard
      bundle_command 'exec guard init'
    end


    def raise_on_unpermitted_parameters
      configure_environment 'development',
        'config.action_controller.action_on_unpermitted_parameters = :raise'
    end

    def configure_mailcatcher
      configure_environment 'development',
        'config.action_mailer.delivery_method = :smtp'
      configure_environment 'development',
        "config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }"
    end

    def configure_generators
      config = <<-RUBY
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_travis
      template 'travis.yml.erb', '.travis.yml'
    end

    def add_ruby_version_file
      current_version = RUBY_VERSION.split('.').map(&:to_i)
      version = if current_version[0] >= 2 && current_version[1] >= 0
                  RUBY_VERSION
                else
                  "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
                end
      add_file '.ruby-version', version
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
                      /Rails.application\.routes\.draw do.*end/m,
                      "Rails.application.routes.draw do\nend"
    end

    def install_devise
      generate 'devise:install'
      generate 'controller', 'root index'
      remove_routes_comment_lines
      inject_into_file 'config/routes.rb',
                       "  root to: 'root#index'\n",
                       after: "Rails.application.routes.draw do\n"
      if options[:devise_model].present?
        generate 'devise', options[:devise_model]
      end
    end

    def setup_capistrano
      copy_file 'Capfile', 'Capfile'
      template 'deploy.rb.erb', 'config/deploy.rb'
      template 'deploy_production.rb.erb', 'config/deploy/production.rb'
      template 'deploy_staging.rb.erb', 'config/deploy/staging.rb'
      template 'capistrano_dotenv.cap', 'lib/capistrano/tasks/dotenv.cap'
    end

    def configure_simple_form
      if options[:bootstrap]
        generate 'simple_form:install --bootstrap'
      else
        generate 'simple_form:install'
      end
    end

    def replace_users_factory
      remove_file 'spec/factories/users.rb'
      copy_file 'users_factory.rb', 'spec/factories/users.rb'
    end

    def replace_root_controller_spec
      remove_file 'spec/controllers/root_controller_spec.rb'
      copy_file 'root_controller_spec.rb',
                'spec/controllers/root_controller_spec.rb'
    end

    def setup_gitignore
      [ 'spec/lib',
        'spec/controllers',
        'spec/features',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples' ].each do |dir|
        run "mkdir -p #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def init_git
      run 'git init'
    end

  end
end
