############################ BEGIN GLOBAL ATTRIBUTES #######################################

default["install"]["ssl"]                         = "false"
default["install"]["addhost"]                     = "false"
default["install"]["localhost"]                   = "false"

# Valid values are 'aws', 'gce', 'azure'
default["install"]["cloud"]                       = ""

default["install"]["aws"]["instance_role"]        = "false"


# Set the root installation directory for Hopsworks to /srv/hops
default["install"]["dir"]                         = "/srv/hops"
default["install"]["kubernetes"]                  = "false"

# Directory where to store the suders scripts. The whole chain needs to be owned by root
default["install"]["sudoers"]["scripts_dir"]       = "#{node["install"]["dir"]}/sbin"
default["install"]["sudoers"]["rules"]             = "true"

# Current installed version
default["install"]["current_version"]             = ""

# Update target
default["install"]["version"] = "1.2.0"

# List of released versions
default["install"]["versions"] = "0.1.0,0.2.0,0.3.0,0.4.0,0.4.1,0.4.2,0.5.0,0.6.0,0.6.1,0.7.0,0.8.0,0.8.1,0.9.0,0.9.1,0.10.0,1.0.0,1.1.0"


# These are global attributes which are inherited by all the cookbooks and therefore availabel
# to all of them

default["java"]["install_flavor"]                 = "openjdk"
default['java']['set_etc_environment']            = true
default["java"]["jdk_version"]                    = 8
default["rhel"]["epel"]                           = "true"

default['install']['user']                        = ""
default["install"]["external_users"]              = "false"

default['install']['enterprise']['install']       = "false"
default['install']['enterprise']['download_url']  = nil
default['install']['enterprise']['username']      = nil
default['install']['enterprise']['password']      = nil

############################ END GLOBAL ATTRIBUTES #######################################

default['conda']['version']                       = "2019.10"
# the version of python: either '2' or '3'
default['conda']['python']                        = "3"
default['conda']['nvidia-ml-py']['version']       = "7.352.0"
default['conda']['pydoop']['version']             = "2.0.0"
default['conda']['beam']['version']               = "2.15.0"
default['conda']['beam']['python']['version']     = node['conda']['beam']['version'] + ".3"
# either 'pip' or 'git'
default["conda"]["hops-util-py"]["install-mode"] = "pip"
default["conda"]["hops-util-py"]["branch"]        = "master"
default["conda"]["hops-util-py"]["repo"]          = "logicalclocks"
default["conda"]["hops-util-py"]["minor"]         = "1"
# last digit is the bugfix version, assuming a version format of X.X.X.X
default["conda"]["hops-util-py"]["version"]       = node["install"]["version"] + "." + node["conda"]["hops-util-py"]["minor"]

# node['download_url'] is not set unless overwritten in the cluster definition. If it's not overwritten, download the artifact from snurran
default['conda']['url']                           = node.attribute?(:download_url) ? node['download_url'] + "/Anaconda#{node['conda']['python']}-#{node['conda']['version']}-Linux-x86_64.sh" : "http://snurran.sics.se/hops/Anaconda#{node['conda']['python']}-#{node['conda']['version']}-Linux-x86_64.sh"

default['conda']['user']                          = node['install']['user'].empty? ? 'anaconda' : node['install']['user']
default['conda']['group']                         = node['install']['user'].empty? ? 'anaconda' : node['install']['user']

default['conda']['dir']                           = node['install']['dir'].empty? ? "/srv/hops/anaconda" : node['install']['dir'] + "/anaconda"

default['conda']['home']                          = "#{node['conda']['dir']}/anaconda-#{node['conda']['python']}-#{node['conda']['version']}"
default['conda']['base_dir']                      = "#{node['conda']['dir']}/anaconda"

default['conda']['channels']['default_mirrors']   = ""
default['conda']['channels']['pytorch']           = ""
default['conda']['use_defaults']                  = "true"
default['conda']['repodata_ttl']                  = 43200 # Cache repodata information for 12h

default['conda']['proxy']['http']                 = ""
default['conda']['proxy']['https']                = ""

default['pypi']['index']                          = ""
default['pypi']['index-url']                      = ""
default['pypi']['trusted-host']                   = ""

default["conda"]["default_libs"]                  = %w{ }
#numpy hdfs3 scikit-learn matplotlib pandas


# Additional libs will be installed (in tensorflow::default.rb) for the base environments
default['conda']['additional_libs']               = ""
# Comma separated list of preinstalled libraries users are able to uninstall
default['conda']['libs']                          = "hops, pandas, numpy, matplotlib, maggy, tqdm, Flask, scikit-learn, avro, seaborn, confluent-kafka, hops-petastorm, opencv-python, tfx, tensorflow-model-analysis, pytorch, torchvision"
default['conda']['provided_lib_names']            =  node['conda']['additional_libs'].empty? ? node['conda']['libs'] : "#{node['conda']['libs']}, #{node['conda']['additional_libs']}"
# Comma separated list of preinstalled libraries users are not able to uninstall
default['conda']['preinstalled_lib_names']        = "pydoop, pyspark, tensorboard, jupyterlab, sparkmagic, hdfscontents, pyjks, hops-apache-beam, pyopenssl"

default['conda']['jupyter']['version']['py3']            = "1.1.4"
default['conda']['jupyter']['version']['py2']            = "0.33.12"
## Hopsworks version of JupyterLab-Git pluging, last digit is Hopsworks version
default['conda']['jupyter']['jupyterlab-git']['version'] = "0.8.1.2"
