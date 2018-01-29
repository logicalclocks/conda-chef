default["install"]["dir"]                        = ""
default["install"]["user"]                       = ""

default["conda"]["version"]                      = '5.0.1'
# the version of python: either '2' or '3'
default["conda"]["python"]                       = '2'

default["conda"]["url"]                          = node.attribute?(:download_url) ? node["download_url"] + "/Anaconda#{node["conda"]["python"]}-#{node["conda"]["version"]}-Linux-x86_64.sh" : "https://repo.continuum.io/archive/Anaconda#{node["conda"]["python"]}-#{node["conda"]["version"]}-Linux-x86_64.sh"

default["conda"]["user"]                         = node["install"]["user"].empty? ? "anaconda" : node["install"]["user"]
default["conda"]["group"]                        = node["install"]["user"].empty? ? "anaconda" : node["install"]["user"]

default["conda"]["dir"]                          = node["install"]["dir"].empty? ? "/srv/anaconda" : node["install"]["dir"] + "/anaconda"

default["conda"]["home"]                         = "#{node["conda"]["dir"]}/anaconda-#{node["conda"]["python"]}-#{node["conda"]["version"]}"
default["conda"]["base_dir"]                     = "#{node["conda"]["dir"]}/anaconda"

default["conda"]["accept_license"]               = 'no'
