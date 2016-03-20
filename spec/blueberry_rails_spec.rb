require 'minitest/autorun'
require './spec/support/blueberry_rails_helpers.rb'

class BlueberryRailsTest < Minitest::Test
  include BlueberryRailsHelpers

  def setup
    remove_project_directory
    cmd 'dropdb test_project_development'
    cmd 'dropdb test_project_test'
  end

  def run
    Bundler.with_clean_env do
      super
    end
  end

  def test_rake_runs_cleanly
    create_project

    assert_exist_file 'config/initializers/simple_form.rb'
    assert_exist_file '.hound.yml'
    assert_exist_file '.rubocop.yml'
    assert_exist_file '.rspec'
    assert_file_have_content 'README.md', 'Test Project'
    assert run_rake
  end

  def test_rake_runs_with_capistrano_option
    create_project '--capistrano'

    assert_file_have_content 'Gemfile', 'capistrano'

    assert_exist_file 'Capfile'
    assert_exist_file 'config/deploy.rb'
    assert_exist_file 'config/deploy/production.rb'
    assert_exist_file 'config/deploy/staging.rb'
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

  def test_rake_runs_with_fontcustom_option
    create_project '--fontcustom'

    assert_exist_file 'lib/tasks/icons.rake'
    assert_exist_file 'fontcustom.yml'
    assert_exist_file "app/assets/icons/_font_icons.scss"

    assert run_rake
  end

  def test_rake_runs_with_gulp_option
    create_project '--gulp'

    assert_file_have_content 'config/environments/development.rb',
                             'config.assets.digest = false'
    assert_exist_file 'gulp/tasks/default.coffee'
    assert_exist_file 'gulpfile.js'
    assert_exist_file 'package.json'
    assert run_rake
  end
end
