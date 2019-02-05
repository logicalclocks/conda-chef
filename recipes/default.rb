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
end

#
# Install libraries into the root environment
#
for lib in node["conda"]["default_libs"] do
  bash "install_anconda_default_libs" do
    user node['conda']['user']
    group node['conda']['group']
    umask "022"
    environment ({'HOME' => "/home/#{node['conda']['user']}"})
    cwd "/home/#{node['conda']['user']}"
    code <<-EOF
      #{node['conda']['base_dir']}/bin/conda install -q -y #{lib}
    EOF
# The guard checks if the library is installed. Be careful with library names like 'sphinx' and 'sphinx_rtd_theme' - add space so that 'sphinx' doesnt match both.
    not_if  "#{node['conda']['base_dir']}/bin/conda list | grep \"#{lib}\"", :user => node['conda']['user']
  end
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
bash "create_hops-system_env" do
  user 'root'
  group 'root'
  umask "022"
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    su #{node['conda']['user']} -c "HADOOP_HOME=#{node['install']['dir']}/hadoop \
       #{node['conda']['base_dir']}/bin/conda env create -q --file hops-system-environment.yml"
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
