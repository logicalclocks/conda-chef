
default["install"]["ssl"]                        = "false"
default["install"]["cleanup_downloads"]          = "false"
default["install"]["upgrade"]                    = "false"
default["install"]["addhost"]                    = "false"

# Set the root installation directory for Hopsworks to /srv/hops
default["install"]["dir"]                        = "/srv/hops"

# Current installed version
default["install"]["current_version"]            = ""

# Update target
default["install"]["version"]                    = "0.7.0-SNAPSHOT"

# List of released versions
default["install"]["versions"]                   = "0.1.0,0.2.0,0.3.0,0.4.0,0.4.1,0.4.2,0.5.0,0.6.0,0.6.1"

default['install']['user']                       = ""

default['conda']['version']                      = "5.2.0"
# the version of python: either '2' or '3'
default['conda']['python']                       = "2"

# node['download_url'] is not set unless overwritten in the cluster definition. If it's not overwritten, download the artifact from snurran
default['conda']['url']                          = node.attribute?(:download_url) ? node['download_url'] + "/Anaconda#{node['conda']['python']}-#{node['conda']['version']}-Linux-x86_64.sh" : "http://snurran.sics.se/hops/Anaconda#{node['conda']['python']}-#{node['conda']['version']}-Linux-x86_64.sh"

default['conda']['user']                         = node['install']['user'].empty? ? 'anaconda' : node['install']['user']
default['conda']['group']                        = node['install']['user'].empty? ? 'anaconda' : node['install']['user']

default['conda']['dir']                          = node['install']['dir'].empty? ? "/srv/hops/anaconda" : node['install']['dir'] + "/anaconda"

default['conda']['home']                         = "#{node['conda']['dir']}/anaconda-#{node['conda']['python']}-#{node['conda']['version']}"
default['conda']['base_dir']                     = "#{node['conda']['dir']}/anaconda"

default['conda']['mirror_list']                  = ""
default['conda']['use_defaults']                 = "true"

default["conda"]["default_libs"]                   = %w{ }
#numpy hdfs3 scikit-learn matplotlib pandas

# Comma separated list of provided library names we install for users
default['conda']['provided_lib_names']           = "hops, pandas, tensorflow-serving-api, hopsfacets, mmlspark, numpy"
# Comma separated list of preinstalled libraries users should not touch
default['conda']['preinstalled_lib_names']       = "tensorflow-gpu, tensorflow, pydoop, pyspark, tensorboard, jupyter, sparkmagic, hdfscontents"
