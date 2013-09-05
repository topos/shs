namespace :cabal do
  desc "install cabal-dev packages"
  task :install, [:cabal] do |t,arg|
    pkgs = `rake cabal:list`.split("\n").map{|l|l.strip.split.join('-')}
    Dir.chdir(LIB_DIR) do
      pkg_list = []
      File.readlines('./cabal-dev.list').map{|l|l.strip}.each do |pkg|
        next if pkg =~ /^\s*#.*$/ || pkg =~ /^\s*$/
        unless pkgs.include?(pkg)
          pkg_list << pkg
        else
          puts "#{pkg} " + "already installed".green
        end
      end
      if pkg_list.size > 0
        sh "cabal-dev update"
        pkg_list.each do |pkg|
          if platform?('linux')
            sh "cabal-dev install #{pkg}"
          elsif platform?('darwin')
            sh "cabal-dev install --extra-include-dirs=#{EXTRA_INC} --extra-lib-dirs=#{EXTRA_LIB} #{pkg}"
          else
            raise "unrecognized platform"
          end
        end
      end
    end
  end

  desc "list cabal-dev packages"
  task :list, [:cabal,:remote] do |t,arg|
    Dir.chdir(LIB_DIR) do
      if arg.cabal.nil?
        sh "cabal-dev list --installed --simple-output"
      else
        if arg.remote.nil?
          sh "cabal-dev list --installed --simple-output #{arg.cabal}"
        else
          sh "cabal-dev list --simple-output #{arg.cabal}"
        end
      end
    end
  end
  
  desc "init. dev. env."
  task :init do
    Dir.chdir(LIB_DIR) do
      sh "cabal update"
      sh "cabal install cabal-dev"
      sh "cabal-dev update"
    end
  end
  
  desc "clean (remove) cabal-dev from dev. env."
  task :clean do
    sh "rm -rf #{LIB_DIR}/cabal-dev"
  end
end
