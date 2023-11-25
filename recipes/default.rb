conda_user_home = conda_helpers.get_user_home(node['conda']['user'])

bash "create_base" do
  user node['conda']['user']
  group node['conda']['group']
  umask "022"
  environment ({'HOME' => conda_user_home})
  cwd conda_user_home
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
  cwd conda_user_home
  code <<-EOF
    #{node['conda']['base_dir']}/bin/conda env remove -y -q -n hops-system
  EOF
  only_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end

bash "create_hops-system_env" do
  user 'root'
  group 'root'
  umask "022"
  cwd conda_user_home
  environment ({
    'CXXFLAGS':'-I/usr/include/tirpc',
    'CFLAGS':'-I/usr/include/tirpc'
  })
  code <<-EOF
    set -e
    su #{node['conda']['user']} -c "#{node['conda']['base_dir']}/bin/conda env create -q --file hops-system-environment.yml"

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
  environment ({'HOME' => conda_user_home})
  cwd conda_user_home
  code <<-EOF
    #{node['conda']['base_dir']}/envs/hops-system/bin/pip install --upgrade setuptools==44.1.1 pip
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
    chmod -R 755 #{node['conda']['base_dir']}/envs/hops-system
  EOF
  only_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end
