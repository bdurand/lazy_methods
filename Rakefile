require 'rubygems'
require 'rake'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

begin
  require 'rspec'
  require 'rspec/core/rake_task'
  desc 'Run the unit tests'
  RSpec::Core::RakeTask.new(:test)
rescue LoadError
  task :test do
    STDERR.puts "You must have rspec 2.0 installed to run the tests"
  end
end

desc 'Generate documentation for the gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--title' << 'Lazy Methods' << '--line-numbers' << '--inline-source' << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lazy_methods"
    gem.summary = %Q{Gem that adds lazy method wrapping to every object. Preceding any method with lazy_ will defer the invocation until the result is actually needed.}
    gem.description = %Q(Gem that adds lazy method wrapping to every object. Preceding any method with lazy_ will defer the invocation until the result is actually needed. This pattern is useful when used with caching systems.)
    gem.email = "brian@embellishedvisions.com"
    gem.homepage = "http://github.com/bdurand/lazy_methods"
    gem.authors = ["Brian Durand"]
    gem.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc"]
    
    gem.add_development_dependency('rspec', '>= 2.0.0')
    gem.add_development_dependency('jeweler')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
end
