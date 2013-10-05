namespace :lxc do
  desc "start an lx container"
  task :start, [:name,:state] do |t,arg|
    raise "error: lxc \"name\" is required" if arg.name.nil?
    3.times do
      begin
        sh "sudo lxc-start -d -n #{arg.name}"
      rescue
        sleep 3
        retry
      end
      break
    end
    sh "sudo lxc-wait -n #{arg.name} -s #{arg.state}" unless arg.state.nil?
  end

  desc "stop an lx container gracefully or immediately"
  task :stop, [:name] do |t,arg|
    raise "error: lxc \"name\" is required" if arg.name.nil?
    arg.with_defaults(stop:false)
    unless arg.stop
      gracetime = 10
      sh "sudo lxc-shutdown -t #{gracetime} -n #{arg.name}"
    else
      sh "sudo lxc-stop -n #{arg.name}"
    end
  end

  desc "stop any lx container in a running state"
  task :startall do
    `sudo lxc-ls --stopped`.strip.split(/\s+/).each do |name|
      task('lxc:start').reenable
      task('lxc:start').invoke(name)
    end
  end

  desc "stop any lx container in a stopped state"
  task :stopall do
    `sudo lxc-ls --running`.strip.split(/\s+/).each do |name|
      task('lxc:stop').reenable
      task('lxc:stop').invoke(name)
    end
  end

  desc "a synonym for lxc:attach"
  task :exec, [:name,:cmd] => :attach

  desc "exec a command in a container"
  task :attach, [:name,:cmd] do |t,arg|
    raise "error: \"name\" and/or \"command\" missing" if arg.name.nil? || arg.cmd.nil?
    sh "sudo lxc-attach -n #{arg.name} -- #{arg.cmd}"
  end

  desc "install packages"
  task :install, [:name,:packages] do |t,arg|
    raise "error: lxc \"name\" is required" if arg.name.nil?
    task("lxc:exec").reenable
    task("lxc:exec").invoke(arg.name,'sudo apt-get update -y')
    arg.packages.split(/\s+/).map{|pkg|"sudo apt-get install -y #{pkg}"}.each do |cmd|
      task("lxc:exec").reenable
      task("lxc:exec").invoke(arg.name,cmd)
    end
  end

  desc "login"
  task :login, [:name] do |t,arg|
    raise "error: lxc \"name\" is required" if arg.name.nil?
    sh "sudo lxc-console -n #{arg.name}"
  end

  desc "list"
  task :list do
    sh "sudo lxc-ls --fancy"
  end

  desc "lxc ps"
  task :ps, [:opt] do |t,arg|
    if arg.option.nil?
      sh "sudo lxc-ps -n plain"
    else
      sh "sudo lxc-ps -n plain -- #{arg.option}"
    end
  end

  desc "destroy lx container"
  task :destroy, [:name] do |t,arg|
    raise "error: lxc \"name\" is required" if arg.name.nil?
    sh "sudo lxc-destroy -n #{arg.name}"
  end

  task :create => :make
  desc "make a linux container"
  task :make, [:name,:template,:release] do |t,arg|
    arg.with_defaults(name:"linux",template:"ubuntu",release:nil)
    cmd = [] << "lxc-create -t ubuntu -n #{arg.name}"
    cmd << "-n #{arg.name}"
    cmd << "-- -r #{arg.release}" unless arg.release.nil?
    sh "sudo #{cmd.join(' ')}"
    task(:install_packages).invoke("lxc","--no-install-recommends")
  end

  task :install_packages, [:name,:packages,:opt] do |t,arg|
    unless arg.name.nil? || arg.packages.nil?
      pkgs = arg.packages.split(',').map{|p|p.strip}.join(' ')
      puts "sudo chroot /var/lib/lxc/#{arg.name}/rootfs 'sudo apt-get install -y #{arg.opt||''} #{pkgs}'"
      sh "sudo chroot /var/lib/lxc/#{arg.name}/rootfs sudo apt-get install -y #{arg.opt||''} #{pkgs}"
    else
      puts "warning [noop]: \"name\" and/or \"packages\" missing"
    end
  end

  desc "initialize/install lxc"
  task :init => [:install,:network_config]

  desc "install lxc"
  task :install do
    sh "sudo aptitude update -y"
    sh "sudo aptitude install -y lxc"
  end

  desc "configure outbound IP traffic from a container"
  task :network_config do
    # ! may not be needed anymore
    # dotdir =   File.expand_path(File.dirname(__FILE__))
    # if File.exists?("/etc/lxc/default.conf") && !File.exists?("/etc/lxc/default.conf.orig")
    #   Dir.chdir("/etc/lxc") do
    #     sh "sudo mv -f default.conf default.conf.orig"
    #   end
    # end
    # sh "sudo cp #{dotdir}/lxc_default.conf /etc/lxc/default.conf"
  end

  # @todo: automate
  desc "configure bridge network on primary host"
  task :bridge_network do
    puts "- append the following to /etc/network/interfaces:"
    puts "auto lxcbr0"
    puts "iface br0 inet static"
    puts "    bridge_ports eth0"
    puts "    bridge_stp off"
    puts "    bridge_fd 0"
    puts "    bridge_maxwait 0"
    puts "- and comment out \"eth0\" fragment"
  end
end
