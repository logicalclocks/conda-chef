name              "conda"
maintainer        "Jim Dowling"
maintainer_email  'jdowling@kth.se'
license           'Apache v.2'
description       'Installs/Configures conda'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"

supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 16.04'
supports 'centos', '= 7.2'

depends           'magic_shell'
depends           'ulimit'
depends           'java'

recipe "conda::install", "Installs  conda"
recipe "conda::default", "Configures conda"

################################ Begin installation wide attributes ########################################

attribute "rhel/epel",
          :description => "Install epel-release package on rhel/centos",
          :type => 'string'

attribute "install/external_users",
          :description => "Set to true if the service accounts are managed externally, such as from LDAP, (Default: False)",
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
          :description => "Default ''. Set to a base directory under which all hops services will be installed.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

attribute "install/enterprise/install",
          :description => "Set to true if installing Hopsworks EE",
          :type => "string"

attribute "install/enterprise/download_url",
          :description => "Download URL for Hopsworks EE, similar to download_url",
          :type => "string"

attribute "install/enterprise/username",
          :description => "Username for protected artifacts",
          :type => "string"

attribute "install/enterprise/password",
          :description => "Password for protected artifacts",
          :type => "string"

attribute "install/upgrade",
          :description => "User to upgrade the software",
          :type => "string"

attribute "install/ssl",
          :description => "Is SSL turned on for all services?",
          :type => "string"

attribute "install/cleanup_downloads",
          :description => "Remove any zipped binaries that were downloaded and used to install services",
          :type => "string"

attribute "install/addhost",
          :description => "Indicates that this host will be added to an existing Hops cluster.",
          :type => "string"

attribute "install/current_version",
          :description => "Current installed Hopsworks version",
          :type => "string"

attribute "install/version",
          :description => "Hopsworks target install version.",
          :type => "string"

attribute "install/versions",
          :description => "Comma-separated list of previous versions of Hopsworks.",
          :type => "string"

attribute "install/localhost",
          :description => "Set to 'true' for a localhost installation. Default is 'false'",
          :type => 'string'

attribute "install/cloud",
          :description => "Set to '' for no cloud provider. Valid values are: 'aws', 'gce', 'azure'.",
          :type => 'string'

attribute "install/aws/instance_role",
          :description => "Set to true if using AWS and authorization should be done using the instance role",
          :type => 'string'

attribute "conda/channels/default_mirrors",
          :description => "comma separated list of anaconda mirrors",
          :type => "string"

attribute "conda/channels/pytorch",
          :description => "channel to use for pytorch packages",
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

attribute "conda/libs",
          :description => "Comma separated list of provided library names we install for the base conda envs",
          :type => "string"

attribute "conda/additional_libs",
          :description => "Comma separated list of additional provided library names we install for the base conda envs",
          :type => "string"

attribute "conda/preinstalled_lib_names",
          :description => "Comma separated list of preinstalled libraries users should not touch",
          :type => "string"

attribute "conda/hops-util-py/install-mode",
          :description => "The mode for installing hops-util-py, either 'pip' to install a specific version or 'git' to install a specific branch",
          :type => "string"

attribute "conda/hops-util-py/branch",
          :description => "The branch to install hops-util-py from git",
          :type => "string"

attribute "conda/hops-util-py/repo",
          :description => "The repository where to install hops-util-py from git, e.g if you want to install logicalclocks/hops-util/py, set this string to 'logicalclocks'",
          :type => "string"

attribute "conda/hops-util-py/version",
          :description => "The version to install hops-util-py from pip",
          :type => "string"

attribute "conda/hops-util-py/minor",
          :description => "The bugfix version for hops-util-py",
          :type => "string"

attribute "conda/pydoop/version",
          :description => "Pydoop version to install in python base environments",
          :type => "string"

attribute "conda/nvidia-ml-py/version",
          :description => "nvidia-ml-py version to install in python base environments",
          :type => "string"

attribute "conda/jupyter/jupyterlab-git/version",
          :description => "Version of Hopsworks version of jupyterlab-git plugin",
          :type => 'string'
