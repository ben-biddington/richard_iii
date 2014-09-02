require "bundler/gem_tasks"

require 'rake/testtask'

namespace :test do 
  %w{unit integration acceptance}.each do |name|
    Rake::TestTask.new do |t|
      t.name = name		   
      t.test_files = FileList["test/#{name}.tests/**/*.rb"]
    end
  end	  

  desc "Run all tests"
  task :all => ["test:unit", "test:integration", "test:acceptance"]
end

task :default => "test:unit"
