class MakefileGenerator
  attr_reader :skip_brakeman

  def self.generate(config)
    new(config).generate
  end

  def initialize(config)
    @config = config
    @app_path = config.app_path
    @skip_brakeman = config.skip_options&.include?('--skip-brakeman')
  end

  def generate
    content = render_template
    write_makefile(content)
    puts "Makefile has been generated in #{makefile_path}"
  end

  private

  def render_template
    template = File.read(template_path)
    erb = ERB.new(template, trim_mode: '-')
    erb.result(binding)
  end

  def template_path
    File.join(File.dirname(__dir__), 'templates', 'Makefile.erb')
  end

  def makefile_path
    File.join(@app_path, 'Makefile')
  end

  def write_makefile(content)
    File.write(makefile_path, content)
  end
end
