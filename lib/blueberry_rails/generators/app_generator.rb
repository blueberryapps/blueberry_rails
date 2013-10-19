require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module BlueberryRails
  class AppGenerator < Rails::Generators::AppGenerator

    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
    :esc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    # class_option :github, :type => :string, :aliases => '-G', :default => nil,
    #   :desc => 'Create Github repository and add remote origin pointed to repo'

    class_option :devise, :type => :boolean, :aliases => '-D', :default => true,
      :desc => 'Include and generate devise'

    class_option :devise_model, :type => :string, :aliases => '-M', :default => 'User',
      :desc => 'Name of devise model to generate'

    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
      :desc => 'Skip Test::Unit files'

    def finish_template
      invoke :blueberry_customization
      super
    end

    def blueberry_customization
      invoke :customize_gemfile
      invoke :setup_database
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_staging_environment
      invoke :create_views
      invoke :configure_app
      invoke :remove_routes_comment_lines
      invoke :setup_gems
      invoke :setup_git
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used
      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :configure_generators
      build :raise_on_unpermitted_parameters
      build :configure_mailcatcher
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :generate_rspec
      build :configure_rspec
      build :setup_rspec_support_files
      build :test_factories_first
      build :init_guard
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def create_views
      build :create_partials_directory
      build :create_shared_flashes
      build :create_application_layout
    end

    def configure_app
      build :replace_secret_token
      build :disable_xml_params
      build :setup_mailer_hosts
      build :remove_turbolinks
      build :add_ruby_version_file
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def setup_gems
      if options[:devise]
        say 'Setting up devise'
        build :install_devise
      end
      say 'Setting up Capistrano'
      build :setup_capistrano
    end

    def setup_git
      say 'Initializing git'
      build :setup_gitignore
      build :init_git
    end


    def run_bundle
    end

    protected

    def get_builder_class
      BlueberryRails::AppBuilder
    end

  end
end

