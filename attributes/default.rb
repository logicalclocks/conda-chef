############################ BEGIN GLOBAL ATTRIBUTES #######################################

default["install"]["ssl"]                         = "false"
default["install"]["addhost"]                     = "false"
default["install"]["localhost"]                   = "false"
default['install']['homes_directory']             = "/home"

# Generate and setup ssh access among machine
#
# WARNING: This is big security hole
#
default["install"]["dev_ssh_keys"]                = "false"


# Valid values are 'aws', 'gcp', 'azure'
default["install"]["cloud"]                       = ""

default["install"]["aws"]["instance_role"]        = "false"

default["install"]["aws"]["docker"]["ecr-login_dir"]  = "/root/.docker-ecr-login/"

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
default["install"]["version"] = "2.5.0"

# List of released versions
default["install"]["versions"] = "0.1.0,0.2.0,0.3.0,0.4.0,0.4.1,0.4.2,0.5.0,0.6.0,0.6.1,0.7.0,0.8.0,0.8.1,0.9.0,0.9.1,0.10.0,1.0.0,1.1.0,1.2.0,1.3.0,1.4.0,1.4.1,2.0.0,2.1.0,2.2.0,2.3.0,2.4.0"


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

default['install']['bind_services_private_ip']    = "false"

default['hops']['group_id']                       = "1234"

default['logger']['user']                         = "logger"
default['logger']['user_id']                      = "1524"
default['logger']['group']                        = "logger"
default['logger']['group_id']                     = "1519"

# Pypi library versions

default['scikit-learn']['version']                = "0.22.2.post1"  # this version needs to match the one set in docker-images (env.yml)

############################ END GLOBAL ATTRIBUTES #######################################

default['conda']['version']                       = "4.8.3"
default['conda']['python']                        = "py37"

default['conda']['beam']['version']               = "2.24.0"
default['conda']['pydoop']['version']             = "2.0.0"
default['conda']['nvidia-ml-py']['version']       = "7.352.0"

default["conda"]["hops-util-py"]["install-mode"] = "pip"
default["conda"]["hops-util-py"]["branch"]        = "master"
default["conda"]["hops-util-py"]["repo"]          = "logicalclocks"
default["conda"]["hops-util-py"]["minor"]         = "0"
# last digit is the bugfix version, assuming a version format of X.X.X.X
default["conda"]["hops-util-py"]["version"]       = node["install"]["version"] + "." + node["conda"]["hops-util-py"]["minor"]

default['conda']['url']                           = node['download_url'] + "/Miniconda3-#{node['conda']['python']}_#{node['conda']['version']}-Linux-x86_64.sh"

default['conda']['user']                          = node['install']['user'].empty? ? 'anaconda' : node['install']['user']
default['conda']['user_id']                       = '1511'
default['conda']['group']                         = node['install']['user'].empty? ? 'anaconda' : node['install']['user']
default['conda']['group_id']                      = '1507'

default['conda']['dir']                           = node['install']['dir'].empty? ? "/srv/hops/anaconda" : node['install']['dir'] + "/anaconda"

default['conda']['home']                          = "#{node['conda']['dir']}/anaconda-#{node['conda']['python']}-#{node['conda']['version']}"
default['conda']['base_dir']                      = "#{node['conda']['dir']}/anaconda"
# full/minimal
# minimal is used in managed NDB nodes
default['conda']['hops-system']['installation-mode'] = "full"

default['conda']['channels']['default_mirrors']   = ""
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
default['conda']['docker']['image-validation-regex'] = "^([a-z0-9]+(-[a-z0-9]+)*\.)*[a-z0-9]+(:[0-9]*)?(\/([a-zA-Z0-9\-]*))?\/([-:._a-zA-Z0-9]{0,62}[-:.a-zA-Z0-9]$)"
