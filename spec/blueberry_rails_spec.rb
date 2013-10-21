require 'minitest/autorun'
require 'fileutils'

class BlueberryRailsTest < Minitest::Test

  def setup
    FileUtils.rm_rf 'test_project'
    cmd 'dropdb test_project_development'
    cmd 'dropdb test_project_test'
  end

  def test_rake_runs_cleanly_first
    create_project 'test_project'
    run_rake 'test_project'
  end

  protected

  def create_project(project_name)
    bin = File.expand_path(File.join('..', 'bin', 'blueberry_rails'), File.dirname(__FILE__))
    cmd "#{bin} #{project_name}"
  end

  def run_rake(project_name)
    Dir.chdir(project_name) do
      cmd 'bundle exec db:create'
      cmd 'bundle exec db:migrate'
      cmd 'bundle exec db:test:prepare'
      assert cmd('bundle exec rake')
    end
  end

  def cmd(command)
    %x(#{command})
    $?
  end

end
