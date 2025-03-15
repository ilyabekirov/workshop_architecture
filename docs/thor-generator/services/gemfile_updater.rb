class GemfileUpdater
  def self.update(app_path)
    new(app_path).update
  end

  def initialize(app_path)
    @app_path = app_path
    @gemfile_path = File.join(app_path, 'Gemfile')
  end

  def update
    content = File.read(@gemfile_path)
    updated_content = insert_development_gems(content)
    File.write(@gemfile_path, updated_content)
    puts "Gemfile has been updated in #{@gemfile_path}"
  end

  private

  def insert_development_gems(content)
    if content =~ /group :development do/
      insert_into_existing_group(content)
    else
      append_new_group(content)
    end
  end

  def insert_into_existing_group(content)
    content.sub(/group :development do\s*/) do |match|
      "#{match}#{development_gems}"
    end
  end

  def append_new_group(content)
    content + "\n\ngroup :development do\n#{development_gems}end\n"
  end

  def development_gems
    @development_gems ||= <<~GEMS
      gem 'database_consistency', require: false
      gem 'ruboclean', require: false
      gem 'rubocop', require: false
      gem 'rubocop-factory_bot', require: false
      gem 'rubocop-performance', require: false
      gem 'rubocop-rails', require: false
      gem 'rubocop-rspec', require: false
      gem 'rubocop-rspec_rails', require: false
    GEMS
  end
end
