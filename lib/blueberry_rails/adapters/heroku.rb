module BlueberryRails
  module Adapters
    class Heroku
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def create_staging_heroku_app(flags)
        app_name = heroku_app_name_for("staging")

        run_toolbelt_command "create #{app_name} #{flags}", "staging"
      end

      def create_production_heroku_app(flags)
        app_name = heroku_app_name_for("production")

        run_toolbelt_command "create #{app_name} #{flags}", "production"
      end

      def set_heroku_rails_secrets
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add SECRET_KEY_BASE=#{generate_secret}",
            environment,
          )
        end
      end

      def create_review_apps_setup_script
        app_builder.template(
          "bin_setup_review_app.erb",
          "bin/setup_review_app",
          force: true,
        )
        app_builder.run "chmod a+x bin/setup_review_app"
      end

      def create_heroku_application_manifest_file
        app_builder.template "app.json.erb", "app.json"
      end

      def create_heroku_pipeline
        pipelines_plugin = `heroku help | grep pipelines`
        if pipelines_plugin.empty?
          puts "You need heroku pipelines plugin. Run: brew upgrade heroku-toolbelt"
          exit 1
        end

        run_toolbelt_command(
          "pipelines:create #{heroku_app_name} \
            -a #{heroku_app_name}-staging --stage staging",
          "staging",
        )

        run_toolbelt_command(
          "pipelines:add #{heroku_app_name} \
            -a #{heroku_app_name}-production --stage production",
          "production",
        )
      end

      def set_heroku_application_host
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add APPLICATION_HOST=#{heroku_app_name}-#{environment}.herokuapp.com",
            environment,
          )
        end
      end

      private

      attr_reader :app_builder

      def heroku_app_name
        app_builder.app_name.dasherize
      end

      def heroku_app_name_for(environment)
        "#{heroku_app_name}-#{environment}"
      end

      def generate_secret
        SecureRandom.hex(64)
      end

      def run_toolbelt_command(command, environment)
        app_builder.run(
          "heroku #{command} --no-remote",
        )
      end
    end
  end
end
