namespace :yesod do
  desc "start yesod in dev mode--@todo: broken->fix"
  task :start do
    puts "starting yesod".green
    # "PATH=..." is required otherwise it hangs--i dunno
    sh "PATH=#{ENV['PATH']} yesod --dev --verbose devel"
  end

  desc "uninstall and reinstall yesod"
  task :reset => [:clean] do
    sh "rm -rf #{WHS_HOME}/cabal-dev"
    sh "cd #{WHS_HOME} && cabal-dev install"
  end
end
