require File.expand_path('../lazy_methods/lazy_methods', __FILE__)
Object.send(:include, LazyMethods::InstanceMethods) unless Object.include?(LazyMethods::InstanceMethods)
