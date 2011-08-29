require 'rubygems'
require 'rake'

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

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lazy_methods"
    gem.summary = %Q{Gem that adds lazy method delegation methods. Using this gem you can easily define lazy loading or asynchronous versions of specific methods. Lazy loading is useful when used with caching systems while asynchronous methods can improve throughput on I/O bound processes like making several HTTP calls in row.}
    gem.description = %Q{Gem that adds lazy method delegation methods. Using this gem you can easily define lazy loading or asynchronous versions of specific methods. Lazy loading is useful when used with caching systems while asynchronous methods can improve throughput on I/O bound processes like making several HTTP calls in row.}
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
