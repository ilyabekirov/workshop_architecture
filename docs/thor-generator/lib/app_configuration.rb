class AppConfiguration
  attr_accessor :app_path, :database, :skip_options

  def initialize
    @skip_options = []
  end

  def self.create
    config = new
    config.app_path = Prompts.ask_app_path
    config.database = Prompts.ask_database_choice
    config.skip_options = Prompts.ask_skip_options
    config
  end
end
