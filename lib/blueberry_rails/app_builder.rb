module BlueberryRails
  class AppBuilder < Rails::AppBuilder

    include BlueberryRails::ActionHelpers

    def readme
      template 'README.md.erb', 'README.md'
    end

    def gitignore
      template 'gitignore_custom.erb', '.gitignore'
    end

    def gemfile
      template 'Gemfile_custom.erb', 'Gemfile'
    end

    def secret_token
      template 'secret_token.rb.erb', 'config/initializers/secret_token.rb'
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb',
                'config/initializers/disable_xml_params.rb'
    end

    def hound_config
      copy_file '../.hound.yml', '.hound.yml'
      copy_file '../.rubocop.yml', '.rubocop.yml'
    end

    def setup_mailer_hosts
      action_mailer_host 'development', "development.#{app_name}.com"
      action_mailer_host 'test', "test.#{app_name}.com"
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def use_postgres_config_template
      template 'database.yml.erb', 'config/database.yml',
        force: true
      template 'database.yml.erb', 'config/database.yml.sample'
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'

      replace_in_file 'config/environments/staging.rb',
                      'config.consider_all_requests_local       = false',
                      'config.consider_all_requests_local       = true'
    end

    def setup_admin
      directory 'admin_controllers', 'app/controllers/admin'
      directory 'admin_views', 'app/views/admin'

      template 'views/layouts/admin.html.slim.erb',
               'app/views/layouts/admin.html.slim'

      inject_into_file 'config/routes.rb',
                       "\n  namespace :admin do\n" \
                       "    root to: 'dashboard#show'\n" \
                       "  end\n\n",
                       before: "  root"
    end

    def create_partials_directory
      directory 'views/application', 'app/views/application'
    end

    def create_application_layout
      remove_file 'app/views/layouts/application.html.erb'

      template 'views/layouts/application.html.slim.erb',
               'app/views/layouts/application.html.slim'

      remove_file 'app/helpers/application_helper.rb'
      copy_file 'helpers/application_helper.rb',
                'app/helpers/application_helper.rb'

      remove_file 'public/favicon.ico'
      directory 'public/icons', 'public'
    end

    def copy_assets_directory
      remove_file 'app/assets/stylesheets/application.css'
      remove_file 'app/assets/javascripts/application.js'

      directory 'assets', 'app/assets'

      remove_file 'app/assets/icons'

      replace_in_file 'config/initializers/assets.rb',
        '# Rails.application.config.assets.precompile += %w( search.js )',
        'Rails.application.config.assets.precompile += %w( print.css ie.css )'

      if options[:administration]
        directory 'admin_assets', 'app/assets'

        replace_in_file 'config/initializers/assets.rb',
                        '.precompile += %w( ',
                        '.precompile += %w( admin.css admin.js '
      end
    end

    def copy_print_style
      copy_file 'assets/stylesheets/print.sass',
                'app/assets/stylesheets/print.sass'
    end

    def copy_initializers
      if options[:translation_engine]
        copy_file 'config/initializers/translation_engine.rb',
                  'config/initializers/translation_engine.rb'
      end
      if options[:bootstrap]
        copy_file 'config/initializers/simple_form_bootstrap.rb',
                  'config/initializers/simple_form_bootstrap.rb', force: true
      end
      copy_file 'config/initializers/airbrake.rb',
                'config/initializers/airbrake.rb'
    end

    def create_pryrc
      copy_file 'pryrc.rb', '.pryrc'
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def generate_rspec
      generate 'rspec:install'

      inject_into_file 'spec/rails_helper.rb',
                       "\n# Screenshots\n" \
                       "require 'capybara-screenshot/rspec'\n" \
                       "Capybara::Screenshot.autosave_on_failure =\n" \
                       "  (ENV['SCR'] || ENV['AUTO_SCREENSHOT']) == '1'\n",
                       after: "Rails is not loaded until this point!\n"
    end

    def configure_rspec
      copy_file 'spec/spec_helper.rb', 'spec/spec_helper.rb', force: true
    end

    def test_factories_first
      copy_file 'spec/factories_spec.rb', 'spec/models/factories_spec.rb'
    end

    def setup_rspec_support_files
      copy_file 'spec/factory_girl_syntax.rb', 'spec/support/factory_girl.rb'
      copy_file 'spec/database_cleaner_setup.rb', 'spec/support/database_cleaner.rb'
      copy_file 'spec/mail_body_helpers.rb', 'spec/support/mixins/mail_body_helpers.rb'
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

    def configure_i18n
      replace_in_file 'config/application.rb',
                      "# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]",
                      "config.i18n.load_path += Dir[Rails.root.join 'config/locales/**/*.{rb,yml}']"

      replace_in_file 'config/application.rb',
                      '# config.i18n.default_locale = :de',
                      "config.i18n.available_locales = [:cs, :en]\n    config.i18n.default_locale = :cs"

      remove_file 'config/locales/en.yml'
      directory 'locales', 'config/locales'
    end

    def configure_i18n_logger
      configure_environment 'development',
                            "# I18n debug\n  I18nLogger = ActiveSupport::" \
                            "Logger.new(Rails.root.join('log/i18n.log'))"
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
      add_file '.ruby-version', "#{version}\n"
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

      if options[:administration]
        generate 'devise', 'administrator'
        replace_in_file 'app/models/administrator.rb',
                        ' :registerable,',
                        ''
      end

      copy_file 'locales/cs/cs.devise.yml', 'config/locales/cs/cs.devise.yml'

      rename_file 'config/locales/devise.en.yml',
                  'config/locales/en/en.devise.yml'
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

        replace_in_file 'config/initializers/simple_form.rb',
                        '# config.label_text = lambda { |label, required, explicit_label| "#{required} #{label}" }',
                        'config.label_text = lambda { |label, required, explicit_label| "#{required} #{label}" }'

      else
        generate 'simple_form:install'
      end
      rename_file 'config/locales/simple_form.en.yml',
                  'config/locales/en/en.simple_form.yml'
    end

    def replace_users_factory
      copy_file 'spec/factories/users.rb',
                'spec/factories/users.rb', force: true
      if options[:administration]
        copy_file 'spec/factories/administrators.rb',
                  'spec/factories/administrators.rb', force: true
      end
    end

    def replace_root_controller_spec
      copy_file 'spec/controllers/root_controller_spec.rb',
                'spec/controllers/root_controller_spec.rb', force: true
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

    def copy_rake_tasks
      copy_file 'tasks/images.rake', 'lib/tasks/images.rake'
      if options[:fontcustom]
        copy_file 'tasks/icons.rake', 'lib/tasks/icons.rake'
      end
    end

    def copy_custom_errors
      copy_file 'controllers/errors_controller.rb', 'app/controllers/errors_controller.rb'

      config = <<-RUBY
    config.exceptions_app = self.routes

      RUBY

      inject_into_class 'config/application.rb', 'Application', config

      remove_file 'public/404.html'
      remove_file 'public/422.html'
      remove_file 'public/500.html'
    end

    def copy_fontcustom_config
      copy_file 'fontcustom.yml', 'fontcustom.yml'
      copy_file 'assets/icons/_font_icons.scss',
                'app/assets/icons/_font_icons.scss'
    end

    def configure_bin_setup

      original = "# puts \"\\n== Copying sample files ==\"\n  # unless File.exist?(\"config/database.yml\")\n  #   system \"cp config/database.yml.sample config/database.yml\"\n  # end"
      updated = "puts \"\\n== Copying sample files ==\"\n  unless File.exist?(\"config/database.yml\")\n    system \"cp config/database.yml.sample config/database.yml\"\n  end"

      replace_in_file 'bin/setup', original, updated
    end

    # Gulp
    def gulp_files
      copy_file 'gulp/gulp_helper.rb', 'app/helpers/gulp_helper.rb'
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'gulp/application.sass',
                'app/assets/stylesheets/application.sass'
      remove_file 'app/assets/javascripts/application.js'
      copy_file 'gulp/application.js.coffee',
                'app/assets/javascripts/application.js.coffee'

      application do
        "# Make public assets requireable in manifest files\n    "  \
        "config.assets.paths << Rails.root.join('public', 'assets', 'stylesheets')\n    " \
        "config.assets.paths << Rails.root.join('public', 'assets', 'javascripts')\n"
      end

      replace_in_file 'config/environments/development.rb',
                      'config.assets.digest = true',
                      'config.assets.digest = false'

      copy_file 'gulp/rev_manifest.rb', 'config/initializers/rev_manifest.rb'
      copy_file 'gulp/global.coffee',   'gulp/assets/javascripts/global.coffee'
      copy_file 'gulp/message.coffee',  'gulp/assets/javascripts/message.coffee'
      copy_file 'gulp/global.sass',     'gulp/assets/stylesheets/global.sass'
      copy_file 'gulp/config.coffee'
      directory 'gulp/tasks'
      directory 'gulp/util'
      copy_file 'gulp/gulpfile.js',  'gulpfile.js'
      copy_file 'gulp/package.json', 'package.json'
    end

  end
end
