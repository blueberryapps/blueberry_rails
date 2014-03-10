require 'minitest/autorun'
require 'fileutils'

class BlueberryRailsTest < Minitest::Unit::TestCase

  def setup
    FileUtils.rm_rf 'test_project'
    cmd 'dropdb test_project_development'
    cmd 'dropdb test_project_test'

    %w[RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE].each do |key|
      set_env key, nil
    end
  end

  def teardown
    restore_env
  end

  def test_rake_runs_cleanly
    create_project 'test_project'
    assert run_rake('test_project')
  end

  def test_rake_runs_cleanly_with_bootstrap_option
    create_project 'test_project', '--bootstrap'
    assert run_rake('test_project')
  end

  protected

  def create_project(project_name, options = nil)
    bin = File.expand_path(File.join('..', 'bin', 'blueberry_rails'), File.dirname(__FILE__))
    cmd "#{bin} #{project_name} #{options}"
  end

  def run_rake(project_name)
    Dir.chdir(project_name) do
      cmd 'bundle exec rake db:create'
      cmd 'bundle exec rake db:migrate'
      cmd('bundle exec rake')
    end
  end

  def cmd(command)
    system "#{command}"
  end

  def original_env
    @original_env ||= {}
  end

  def set_env(key, value)
    original_env[key] = ENV.delete(key)
    ENV[key] = value
  end

  def restore_env
    original_env.each do |key, val|
      ENV[key] = val
    end
  end

end
