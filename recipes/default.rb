include_recipe "java"

# User anaconda needs access to bin/hadoop to install Pydoop
# This is a hack to get the hadoop group.
# Hadoop group is created in hops::install *BUT*
# Karamel does NOT respect dependencies among install recipies
# so it has to be here and it has to be dirty (Antonis)
hops_group = "hadoop"
if node.attribute?("hops")
  if node['hops'].attribute?("group")
    hops_group = node['hops']['group']
  end
end

group hops_group do
  action :modify
  members ["#{node['conda']['user']}"]
  append true
  not_if { node['install']['external_users'].casecmp("true") == 0 }
  only_if "getent group #{hops_group}"
end

bash "create_base" do
  user node['conda']['user']
  group node['conda']['group']
  umask "022"
  environment ({'HOME' => "/home/#{node['conda']['user']}"})
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    #{node['conda']['base_dir']}/bin/conda create -n #{node['conda']['user']}
  EOF
  not_if "test -d #{node['conda']['base_dir']}/envs/#{node['conda']['user']}", :user => node['conda']['user']
end

kagent_disabled = node['kagent'].attribute?('enabled') && node['kagent']['enabled'].casecmp?("false")

## First we delete the current hops-system Anaconda environment, if it exists
bash "remove_hops-system_env" do
  user 'root'
  group 'root'
  umask "022"
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    #{node['conda']['base_dir']}/bin/conda env remove -y -q -n hops-system
  EOF
  only_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end

## Bash resource in Chef is weird! It does not login
## as the user specifed in 'user' property, nor setup
## the correct environment variables such as USER,
## LOGNAME, USERNAME etc. In order to install Pydoop
## user should have read access to bin/hadoop binary.
## We could have set all the required env vars to anaconda
## but then we would also need to get somehow the hadoop group.
## We cannon include hops-hadoop-chef attribute as there will
## be cyclic dependencies, so this is the only solution that works.
if node['conda']['hops-system']['installation-mode'].casecmp?("full")
  environment_file = "hops-system-environment.yml"
elsif node['conda']['hops-system']['installation-mode'].casecmp?("minimal")
  environment_file = "minimal-hops-system-environment.yml"
else
  raise "Illegal conda/hops-system/installation-mode value"
end

bash "create_hops-system_env" do
  user 'root'
  group 'root'
  umask "022"
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    set -e
    su #{node['conda']['user']} -c "HADOOP_HOME=#{node['install']['dir']}/hadoop PATH=#{node['install']['dir']}/hadoop/bin:$PATH \
       #{node['conda']['base_dir']}/bin/conda env create -q --file #{environment_file}"

    export HOPS_UTIL_PY_VERSION=#{node['conda']['hops-util-py']['version']}
    export HOPS_UTIL_PY_BRANCH=#{node['conda']['hops-util-py']['branch']}
    export HOPS_UTIL_PY_REPO=#{node['conda']['hops-util-py']['repo']}
    export HOPS_UTIL_PY_INSTALL_MODE=#{node['conda']['hops-util-py']['install-mode']}
    if [ $HOPS_UTIL_PY_INSTALL_MODE == "git" ] ; then
        yes | "#{node['conda']['base_dir']}"/envs/hops-system/bin/pip install git+https://github.com/${HOPS_UTIL_PY_REPO}/hops-util-py@$HOPS_UTIL_PY_BRANCH --no-dependencies
    else
        yes | "#{node['conda']['base_dir']}"/envs/hops-system/bin/pip install hops==$HOPS_UTIL_PY_VERSION --no-dependencies
    fi
  EOF
  not_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end

bash "update_pip_hops-system_env" do
  user node['conda']['user']
  group node['conda']['group']
  umask "022"
  environment ({'HOME' => "/home/#{node['conda']['user']}"})
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    #{node['conda']['base_dir']}/envs/hops-system/bin/pip install --upgrade pip       
  EOF
  only_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end

## kagent_utils directory is not accessible by conda user
## install it as root and change permissions
bash "install_kagent_utils" do
  user 'root'
  group 'root'
  umask "022"
  code <<-EOF
    #{node['conda']['base_dir']}/envs/hops-system/bin/pip install -q  #{Chef::Config['file_cache_path']}/kagent_utils
    chown -R #{node['conda']['user']}:#{node['conda']['group']} #{node['conda']['base_dir']}/envs/hops-system
  EOF
  only_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end
