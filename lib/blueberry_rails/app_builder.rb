module BlueberryRails
  class AppBuilder < Rails::AppBuilder

    include BlueberryRails::ActionHelpers

    def readme
      template 'README.md.erb', 'README.md'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile_custom.erb', 'Gemfile'
    end

    def replace_secret_token
      template 'secret_token.rb.erb',
        'config/initializers/secret_token.rb',
        force: true
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
      template 'layout.html.slim.erb',
        'app/views/layouts/application.html.slim',
        force: true
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
      remove_file 'spec/spec_helper.rb'
      copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
    end

    def enable_factory_girl_syntax
      copy_file 'factory_girl_syntax.rb', 'spec/support/factory_girl.rb'
    end

    def init_guard
      bundle_command 'exec guard init'
    end


    def raise_on_unpermitted_parameters
      configure_environment 'development',
        'config.action_controller.action_on_unpermitted_parameters = :raise'
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

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
                      /Application\.routes\.draw do.*end/m,
                      "Application.routes.draw do\nend"
    end

    def install_devise
      generate 'devise:install'
      generate 'controller', 'root index'
      remove_routes_comment_lines
      inject_into_file 'config/routes.rb',
                       "  root to: 'root#index'\n",
                       after: "#{app_const}.routes.draw do\n"
      if options[:devise_model].present?
        generate 'devise', options[:devise_model]
      end
    end

    def setup_gitignore
      remove_file '.gitignore'
      copy_file 'gitignore', '.gitignore'
      [ 'app/views/pages',
        'spec/lib',
        'spec/controllers',
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples' ].each do |dir|
        run "mkdir #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def init_git
      run 'git init'
    end

  end
end
