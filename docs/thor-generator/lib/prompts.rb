require 'thor'

module Prompts
  module_function

  include Thor::Shell

  def ask_app_path
    loop do
      path = Thor::Shell::Basic.new.ask('What will be the path of your application?').strip
      return path unless path.empty?

      Thor::Shell::Basic.new.say('Error: Path cannot be empty. Please enter a valid path.', :red)
    end
  end

  def ask_database_choice
    'postgresql'
  end

  def ask_skip_options
    shell = Thor::Shell::Basic.new
    RailsNewConfig::SKIP_OPTIONS.each_with_object([]) do |(option, description), skip_list|
      answer = shell.ask("Would you like to skip '#{description}'? (yes/no, default: yes)").strip
      answer = 'yes' if answer.empty?
      skip_list << "--skip-#{option}" if answer.downcase.start_with?('y')
    end
  end
end
