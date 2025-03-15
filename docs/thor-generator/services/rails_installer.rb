require 'English'
require 'net/http'
require 'json'
require 'thor'

class RailsInstaller
  class InstallationError < StandardError; end

  RUBYGEMS_API_URL = 'https://rubygems.org/api/v1/gems/rails.json'.freeze

  def initialize(shell: Thor::Shell::Color.new)
    @shell = shell
  end

  def self.check_and_install
    new.check_and_install
  end

  def check_and_install
    if rails_installed?
      check_for_update
    else
      handle_missing_rails
    end
  end

  private

  attr_reader :shell

  def rails_installed?
    Gem::Specification.find_by_name('rails')
    true
  rescue Gem::LoadError
    false
  end

  def handle_missing_rails
    display_message(:red, 'The `rails` gem is not installed.')
    install_rails if prompt_user?('Would you like to install it now?')
  end

  def check_for_update
    current_version = fetch_current_version
    latest_version = fetch_latest_version

    return unless latest_version
    return display_current_version(current_version) if latest_version <= current_version

    handle_update(current_version, latest_version)
  end

  def fetch_current_version
    Gem::Specification.find_by_name('rails').version
  end

  def fetch_latest_version
    response = Net::HTTP.get(URI(RUBYGEMS_API_URL))
    data = JSON.parse(response)
    Gem::Version.new(data['version'])
  rescue StandardError => e
    display_message(:red, "Error fetching latest Rails version: #{e.message}")
    nil
  end

  def handle_update(current_version, latest_version)
    display_message(:yellow, "Current Rails version: #{current_version}")
    display_message(:yellow, "Latest Rails version: #{latest_version}")
    update_rails if prompt_user?('Would you like to update to the latest version?')
  end

  def display_current_version(version)
    display_message(:green, "You have the latest version of Rails (#{version}).")
  end

  def prompt_user?(message)
    answer = shell.ask("#{message} (yes/no, default: yes)").to_s.strip.downcase
    answer.empty? || answer.start_with?('y')
  end

  def display_message(color, message)
    shell.say(message, color)
  end

  def install_rails
    execute_gem_command('install rails', 'install')
  end

  def update_rails
    execute_gem_command('update rails', 'update')
  end

  def execute_gem_command(command, action)
    return if system("gem #{command}")

    raise InstallationError, "Failed to #{action} the `rails` gem."
  ensure
    display_message(:green, "The `rails` gem has been successfully #{action}ed.") if $CHILD_STATUS.success?
  end
end
