class CommandBuilder
  def self.build(config)
    [
      "rails new #{config.app_path}",
      "-d #{config.database}",
      *RailsNewConfig::DEFAULT_OPTIONS,
      *config.skip_options
    ].join(' ')
  end
end
