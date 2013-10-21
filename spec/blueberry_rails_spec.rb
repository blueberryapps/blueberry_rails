require 'minitest/autorun'
require 'fileutils'

class BlueberryRailsTest < Minitest::Test

  def setup
    FileUtils.rm_rf 'test_project'
    `dropdb test_project_development`
    `dropdb test_project_test`
  end

  def test_rake_runs_cleanly_first
    create_project 'test_project'
    run_rake 'test_project'
  end

  protected

  def create_project(project_name)
    bin = File.expand_path(File.join('..', 'bin', 'blueberry_rails'), File.dirname(__FILE__))
    `#{bin} #{project_name}`
  end

  def run_rake(project_name)
    Dir.chdir(project_name) do
      `bundle exec db:create`
      `bundle exec db:migrate`
      `bundle exec db:test:prepare`
      `bundle exec rake`
      assert $?.success?
    end
  end

end
