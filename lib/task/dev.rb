require 'date'
require 'yaml'
require 'smart_colored/extend'

def platform?(p)
  `uname -s`.strip.downcase == p.downcase
end

def proj_dir(subdir =nil)
  path = [] << PROJ_HOME
  path << subdir unless subdir.nil?
  path.join('/')
end

def process_running?(name, argfilter =nil)
  require 'sys/proctable'
  include Sys
  ProcTable.ps do |proc|
    if argfilter.nil?
      return true if proc.comm == name
    else
      return true if proc.comm == name && proc.cmdline.split.include?(argfilter)
    end
  end
  false
end

def proj_mode
  ENV['PROJ_MODE'].nil? ? 'Development' : ENV['PROJ_MODE']
end

PROJ_HOME = File.expand_path("#{File.dirname(__FILE__)}/../../.")

SRC_DIR = proj_dir('src')
ETC_DIR = proj_dir('etc')
LIB_DIR = proj_dir('lib')
CABAL_DEV_DIR = proj_dir('lib/cabal-dev')

GHC_PACKAGE_PATH = "#{PROJ_HOME}/lib/cabal-dev/packages-7.6.3.conf"
EXTRA_INC, EXTRA_LIB = if platform?('darwin')
                         ['/opt/local/include', '/opt/local/lib']
                       else
                         ['', '']
                       end
GHC = "ghc -no-user-package-db -package-db #{GHC_PACKAGE_PATH} -threaded"

_path = []
_path << "#{PROJ_HOME}/bin"
_path << "#{PROJ_HOME}/lib/cabal-dev/bin"
_path << '~/.cabal/bin'
_path << if platform?('darwin')
           '~/Library/Haskell/bin'
         else
           '/opt/hp/bin'
         end
_path << '/usr/local/bin'
_path << '/opt/local/bin'
_path << '/usr/bin'
_path << '/bin'

ENV['PATH'] = _path.join(':')
