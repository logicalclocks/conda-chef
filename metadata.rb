name              "conda"
maintainer        "Jim Dowling"
maintainer_email  'jdowling@kth.se'
license           'Apache v.2'
description       'Installs/Configures conda'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.4.0"

supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 16.04'
supports 'centos', '= 7.2'

depends 'magic_shell', '~> 1.0.0'
depends 'java', '~> 7.0.0'
depends 'ulimit'

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

attribute "install/bind_services_private_ip",
          :description => "Flag to bind services to their private IP instead of 0.0.0.0 Default is false",
          :type => "string"

attribute "install/ssl",
          :description => "Is SSL turned on for all services?",
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

attribute "install/kubernetes",
          :description => "Set to true if you want to deploy the kubernetes enterprise edition. Default is 'fasle'",
          :type => 'string'

attribute "install/aws/instance_role",
          :description => "Set to true if using AWS and authorization should be done using the instance role",
          :type => 'string'
    
attribute "install/sudoers/scripts_dir",
          :description => "Location for the Hopsworks script requiring sudoers, (default: /srv/hops/sbin)",
          :type => 'string'

attribute "install/sudoers/rules",
          :description => "Whether or not to add the rules in /etc/sudoers.d/, (default: true)",
          :type => 'string'

attribute "conda/channels/default_mirrors",
          :description => "comma separated list of anaconda mirrors",
          :type => "string"

attribute "conda/use_defaults",
          :description => "whether or not to add the defaults mirrors to the channels list (default yes)",
          :type => "string"

attribute "conda/proxy/http",
          :description => "Proxy configuration for conda (http)",
          :type => "string"

attribute "conda/proxy/https",
          :description => "Proxy configuration for conda (https)",
          :type => "string"

attribute "conda/default_libs",
          :description => "Space separated list of libraries to be installed in Conda root environment",
          :type => "string"

attribute "pypi/proxy",
          :description => "HTTP proxy for fetching libraries from PyPI",
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

attribute "conda/preinstalled_lib_names",
          :description => "Comma separated list of preinstalled libraries users should not touch",
          :type => "string"

attribute "hops/group_id",
          :description => "the group_id for hops/group. If you change this value you must ensure that it match the gid in the docker image",
          :type => 'string'
        
attribute "install/managed_docker_registry",
          :description => "A switch to enable preparations for managed docker registry.",
          :type => 'string'

attribute "install/managed_kubernetes",
          :description => "A switch to enable preparations for managed kubernetes.",
          :type => 'string'

attribute "conda/max_env_yml_byte_size",
          :description => "Maximum size of a conda yml file that may be used to create an environment.",
          :type => 'string'

################################ Begin installation wide attributes ########################################

attribute "conda/docker/image-validation-regex",
          :description => "Validation regex for user/project Docker image name",
          :type => 'string'

################################ end installation wide attributes   ########################################
