require 'erb'
require 'thor'
require_relative 'config/rails_new_config'
require_relative 'lib/app_configuration'
require_relative 'lib/prompts'
require_relative 'services/rails_installer'
require_relative 'services/command_builder'
require_relative 'services/gemfile_updater'
require_relative 'services/makefile_generator'

class RailsNewCLI < Thor
  desc 'generate', 'Generate a new Rails app with custom options'
  def generate
    RailsInstaller.check_and_install

    config = AppConfiguration.create

    generate_application(config)
  end

  private

  def generate_application(config)
    execute_rails_command(config)
    generate_additional_files(config)
  end

  def execute_rails_command(config)
    command = CommandBuilder.build(config)
    say("Running: #{command}", :yellow)
    system(command) || abort('Failed to create Rails application')
  end

  def generate_additional_files(config)
    MakefileGenerator.generate(config)
    GemfileUpdater.update(config.app_path)
  end
end

RailsNewCLI.start(ARGV)
