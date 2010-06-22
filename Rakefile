require 'rubygems'
require 'rake'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

begin
  require 'spec/rake/spectask'
  desc 'Test the gem.'
  Spec::Rake::SpecTask.new(:test) do |t|
    t.spec_files = FileList.new('spec/**/*_spec.rb')
  end
rescue LoadError
  tast :test do
    STDERR.puts "You must have rspec >= 1.3.0 to run the tests"
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
    gem.homepage = "http://github.com/bdurand/acts_as_revisionable"
    gem.authors = ["Brian Durand"]
    gem.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc"]
    
    gem.add_development_dependency('rspec', '>= 1.3.0')
    gem.add_development_dependency('jeweler')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
end
