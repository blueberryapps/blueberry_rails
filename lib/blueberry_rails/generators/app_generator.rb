require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module BlueberryRails
  class AppGenerator < Rails::Generators::AppGenerator

    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
    :esc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :github, :type => :string, :aliases => '-G', :default => nil,
      :desc => 'Create Github repository and add remote origin pointed to repo'

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
      invoke :configure_app
      invoke :remove_routes_comment_lines
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
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :generate_rspec
      build :configure_rspec
      build :enable_factory_girl_syntax
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def configure_app
      build :replace_secret_token
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
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

