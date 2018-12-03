require 'minitest/autorun'
require './spec/support/blueberry_rails_helpers.rb'

class BlueberryRailsTest < Minitest::Test
  include BlueberryRailsHelpers

  def setup
    remove_project_directory
  end

  def run
    Bundler.with_clean_env do
      super
    end
  end

  def test_rake_runs_cleanly
    create_project

    assert_exist_file 'config/initializers/simple_form.rb'
    assert_exist_file 'config/initializers/plurals.rb'
    assert_exist_file '.hound.yml'
    assert_exist_file '.rubocop.yml'
    assert_exist_file '.jshintrc'
    assert_exist_file '.circleci/config.yml'
    assert_exist_file '.rspec'
    assert_exist_file 'app.json'
    assert_exist_file 'spec/support/drivers.rb'
    assert_file_have_content '.ruby-version', BlueberryRails::RUBY_VERSION
    assert_file_have_content 'README.md', 'Test Project'
    assert_file_have_content 'bin/setup', 'bundle install --deployment'
    assert_file_have_content 'Procfile', 'bundle exec puma'
    assert_file_have_content 'config/puma.rb', 'preload_app!'
    assert_file_have_content 'config/environments/production.rb', 'Cache-Control'
    assert_file_have_content 'config/environments/production.rb', 'Rack::Deflater'
    assert_file_have_content 'Guardfile', 'factories'
    assert_file_have_content 'config/initializers/airbrake.rb', 'config.blacklist_keys'

    assert run_rake
  end

  def test_rake_runs_with_no_devise_option
    create_project '--no-devise'

    assert run_rake
  end

  def test_rake_runs_with_bootstrap_option
    create_project '--bootstrap'

    assert_exist_file 'config/initializers/simple_form.rb'
    assert_exist_file 'config/initializers/simple_form_bootstrap.rb'

    assert_file_have_content 'config/initializers/simple_form_bootstrap.rb', 'form-control-wrapper'

    assert run_rake
  end

  def test_rake_runs_with_translation_engine_option
    create_project '--translation_engine'

    assert_exist_file 'config/initializers/translation_engine.rb'
    assert_file_have_content 'Gemfile', 'translation_engine'

    assert run_rake
  end

  def test_rake_runs_with_administration_option
    create_project '--bootstrap --administration'

    assert_exist_file 'app/controllers/admin/dashboard_controller.rb'
    assert_exist_file 'app/views/admin/dashboard/show.html.slim'
    assert_file_have_content 'config/routes.rb', 'namespace :admin'

    assert run_rake
  end

  def test_rake_runs_with_custom_errors_option
    create_project '--custom-errors'

    assert_exist_file 'app/controllers/errors_controller.rb'
    assert_file_have_content 'config/application.rb', 'config.exceptions_app'

    assert run_rake
  end

  def test_rake_runs_with_heroku_option
    create_project '--heroku'

    assert_exist_file 'app.json'
    assert run_rake
  end
end
