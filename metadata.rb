name              "conda"
maintainer        "Jim Dowling"
maintainer_email  'jdowling@kth.se'
license           'Apache v.2'
description       'Installs/Configures conda'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.0"

supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 16.04'
supports 'centos', '= 7.2'

depends           'magic_shell'
depends           'apache2'
depends           'ulimit'
depends           'java'

recipe "conda::install", "Installs  conda"
recipe "conda::default", "Configures conda"
recipe "conda::repo", "Installs a conda repo on an apache server"

################################ Begin installation wide attributes ########################################

attribute "rhel/epel",
          :description => "Install epel-release package on rhel/centos",
          :type => 'string'

################################ end installation wide attributes   ########################################

attribute "conda/dir",
          :description => "Base installation directory for Conda",
          :type => 'string'

attribute "conda/user",
          :description => "User that runs conda",
          :type => 'string'

attribute "conda/group",
          :description => "Group that runs conda",
          :type => 'string'

attribute "install/dir",
          :description => "Set to a base directory under which we will install.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

attribute "conda/mirror_list",
          :description => "comma separated list of anaconda mirrors",
          :type => "string"

attribute "conda/use_defaults",
          :description => "whether or not to add the defaults mirrors to the channels list (default yes)",
          :type => "string"

attribute "conda/default_libs",
          :description => "Space separated list of libraries to be installed in Conda root environment",
          :type => "string"

attribute "pypi/index",
          :description => "Mirror endpoint for PIP search",
          :type => "string"

attribute "pypi/index-url",
          :description => "Mirror endpoint for PIP install and PIP actions which use PEP503 compliant API",
          :type => "string"

attribute "pypi/trusted-host",
          :description => "Trusted host for non https pypi mirrors",
          :type => "string"

attribute "conda/provided_lib_names",
          :description => "Comma separated list of provided library names we install for users",
          :type => "string"

attribute "conda/preinstalled_lib_names",
          :description => "Comma separated list of preinstalled libraries users should not touch",
          :type => "string"
