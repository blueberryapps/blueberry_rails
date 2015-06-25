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

  def test_rake_runs_with_capistrano_option
    create_project '--no-devise'

    assert run_rake
  end

  def test_rake_runs_with_bootstrap_option
    create_project '--bootstrap'

    assert_exist_file 'config/initializers/simple_form.rb'
    assert_exist_file 'config/initializers/simple_form_bootstrap.rb'
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
