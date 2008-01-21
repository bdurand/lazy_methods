require 'lazy_methods/lazy_methods'
Object.send(:include, LazyMethods::InstanceMethods) unless Object.include?(LazyMethods::InstanceMethods)
