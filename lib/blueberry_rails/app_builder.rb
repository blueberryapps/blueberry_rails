module BlueberryRails
  class AppBuilder < Rails::AppBuilder

    def readme
      template 'README.md.erb', 'README.md'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'Gemfile_custom', 'Gemfile'
    end

    def replace_secret_token
      template 'secret_token.rb.erb',
        'config/initializers/secret_token.rb',
        force: true
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
      after: /source 'https:\/\/rubygems.org'/
    end

    def use_postgres_config_template
      template 'database.yml.erb', 'config/database.yml',
        force: true
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

  end
end

