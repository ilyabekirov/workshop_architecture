module RailsNewConfig
  SKIP_OPTIONS = [
    ['action_mailer', 'Action Mailer'],
    ['active_job', 'Active Job'],
    ['active_storage', 'Active Storage'],
    ['action_cable', 'Action Cable'],
    ['solid', 'Solid'],
  ].freeze

  # Actual options for Rails 8.0 [rails new --help]
  DEFAULT_OPTIONS = [
    '--skip-git', # Skip git init, .gitignore and .gitattributes
    '--skip-docker', # Skip Dockerfile, .dockerignore and bin/docker-entrypoint
    '--skip-action-mailbox', # Skip Action Mailbox gem
    '--skip-action-text', # Skip Action Text gem
    '--skip-asset-pipeline', # Indicates when to generate skip asset pipeline
    '--skip-javascript', # Skip JavaScript files
    '--skip-hotwire', # Skip Hotwire integration
    '--skip-jbuilder', # Skip jbuilder gem
    '--skip-test', # Skip test files
    '--skip-system-test', # Skip system test files
    '--skip-bootsnap', # Skip bootsnap gem
    '--skip-dev-gems', # Skip development gems (e.g., web-console)
    '--skip-thruster', # Skip Thruster setup
    '--skip-rubocop', # Skip RuboCop setup
    '--skip-ci', # Skip GitHub CI files
    '--skip-kamal', # Skip Kamal setup
    '--skip-dev', # Set up the application with Gemfile pointing to your Rails checkout
    '--skip-devcontainer', # Generate devcontainer files
    '--skip-edge', # Set up the application with a Gemfile pointing to the 8-0-stable branch on the Rails repository
    '--skip-main', # Set up the application with Gemfile pointing to Rails repository main branch
    '--api', # Preconfigure smaller stack for API only apps
    '--minimal' # Preconfigure a minimal rails app
  ].freeze
end
