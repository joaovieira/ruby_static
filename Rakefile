# encoding: UTF-8

require 'rake'
require 'rake/rdoctask'

desc 'Generate documentation for Ruby Stats.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Ruby Stats #{VERSION}"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


##remove
def gemspec
  @gemspec ||= begin
    file = File.expand_path('../ruby_stats.gemspec', __FILE__)
    eval(File.read(file), binding, file)
  end
end

desc "Validate Gemspec"
task :gemspec do
  gemspec.validate
end