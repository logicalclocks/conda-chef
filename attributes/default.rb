include_attribute "hops"

default.conda.version = '4.3.1'
# the version of python: either '2' or '3'
default.conda.python = '2'

default.conda.url = "https://repo.continuum.io/archive/Conda#{node.conda.python}-#{node.conda.version}-Linux-x86_64.sh"

default.conda.owner = node.install.user.empty? ? node.hops.user : node.install.user
default.conda.group = node.install.user.empty? ? node.hops.group : node.install.user

default.conda.dir = '/srv'

default.conda.home = "#{node.conda.dir}/anaconda-#{node.conda.python}-#{node.conda.version}"
default.conda.base_dir = "#{node.conda.dir}/anaconda"

default.conda.accept_license = 'no'



