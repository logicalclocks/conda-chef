############################ BEGIN GLOBAL ATTRIBUTES #######################################

default["install"]["ssl"]                         = "false"
default["install"]["addhost"]                     = "false"
default["install"]["localhost"]                   = "false"
default['install']['homes_directory']             = "/home"
default['install']['secondary_region']            = "false"
default['install']['regions']['primary']          = ""
default['install']['regions']['secondary']        = ""

# Default empty means that the services won't be configured to use a different temp directory
default['install']['tmp_directory']               = ""

# Generate and setup ssh access among machine
#
# WARNING: This is big security hole
#
default["install"]["dev_ssh_keys"]                = "false"


# Valid values are 'aws', 'gcp', 'azure'
default["install"]["cloud"]                       = ""

default["install"]["cloud_docker_helper_dir"]  = "/root/.docker-login-helper"

default['install']['managed_docker_registry']         = "false"
default['install']['managed_kubernetes']              = "false"

# Set the root installation directory for Hopsworks to /srv/hops
default["install"]["dir"]                         = "/srv/hops"
# Directory where Hopsworks stateful services will store their data
default['data']['dir']                            = "/srv/hopsworks-data"
default["install"]["kubernetes"]                  = "false"

# Directory where to store the suders scripts. The whole chain needs to be owned by root
default["install"]["sudoers"]["scripts_dir"]       = "#{node["install"]["dir"]}/sbin"
default["install"]["sudoers"]["rules"]             = "true"

# Current installed version
default["install"]["current_version"]             = ""

# Update target
default["install"]["version"] = "3.7.2"

# List of released versions
default["install"]["versions"] = "0.1.0,0.2.0,0.3.0,0.4.0,0.4.1,0.4.2,0.5.0,0.6.0,0.6.1,0.7.0,0.8.0,0.8.1,0.9.0,0.9.1,0.10.0,1.0.0,1.1.0,1.2.0,1.3.0,1.4.0,1.4.1,2.0.0,2.1.0,2.2.0,2.3.0,2.4.0,2.5.0,3.0.0,3.1.0,3.2.0,3.3.0,3.4.0,3.5.0"


# These are global attributes which are inherited by all the cookbooks and therefore available
# to all of them

default["java"]["install_flavor"]                 = "openjdk"
default['java']['set_etc_environment']            = true
default["java"]["jdk_version"]                    = 8
default["rhel"]["epel"]                           = "true"

default['install']['user']                        = ""
default["install"]["external_users"]              = "false"

default["download_url"]                           = "https://repo.hops.works/master"

default['install']['enterprise']['install']       = "false"
default['install']['enterprise']['download_url']  = nil
default['install']['enterprise']['username']      = nil
default['install']['enterprise']['password']      = nil
# Global flag to disable modifying SELinux
default["install"]["modify_selinux"]              = "true"

default["install"]["systemd"]["after"]            = ""

default['install']['bind_services_private_ip']    = "false"

default['hops']['group_id']                       = "1234"

default['logger']['user']                         = "logger"
default['logger']['user_id']                      = "1524"
default['logger']['group']                        = "logger"
default['logger']['group_id']                     = "1519"

default['consul']['enabled']			  = "true"

# Pypi library versions

default['scikit-learn']['version']                = "1.1.1"  # this version needs to match the one set in docker-images (env.yml)

############################ END GLOBAL ATTRIBUTES #######################################

default['conda']['channels']['default_mirrors']   = ""
default['conda']['ssl_verify']                    = "true"
default['conda']['use_defaults']                  = "true"
default['conda']['repodata_ttl']                  = 43200 # Cache repodata information for 12h

default['conda']['proxy']['http']                 = ""
default['conda']['proxy']['https']                = ""

default['pypi']['proxy']                          = ""
default['pypi']['index']                          = ""
default['pypi']['index-url']                      = ""
default['pypi']['extra-index-url']                = ""
default['pypi']['trusted-host']                   = ""

# Comma separated list of preinstalled libraries users are not able to uninstall
default['conda']['preinstalled_lib_names']        = "pydoop, pyspark, jupyterlab, sparkmagic, hdfscontents, pyjks, hops-apache-beam, pyopenssl"

default['conda']['max_env_yml_byte_size']         = "20000"

# Regular expression to sanitize projects Docker images
default['conda']['docker']['image-validation-regex'] = "^([a-z0-9]+(-[a-z0-9]+)*\.)*[a-z0-9]+(:[0-9]*)?(\/([a-zA-Z0-9\-]*))?\/([-:._a-zA-Z0-9]{0,127}[-:.a-zA-Z0-9]$)"
