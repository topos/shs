require File.expand_path("#{File.dirname(__FILE__)}/lib/task/dev.rb")
Dir.glob("#{PROJ_HOME}/lib/task/*.rake"){|p| import p}

desc "start development".green
task :s => :start

desc "compile/link code".green
task :c => 'dev:all'

desc "test code".green
task :t => :test

task :start => ['db:start', 'es:start', 'yesod:start']
task :stop => ['db:stop', 'es:stop']
task :spec => 'dev:spec'
task :test => 'dev:test'
task :clean => 'dev:clean'
task :build => 'dev:build'
task :install => 'dev:install'
task :update => 'dev:update'
task :clean => 'dev:clean'
task :ghci => 'dev:ghci'

task :run => 'run:run'

task :default do; sh "rake -T", verbose: false; end
