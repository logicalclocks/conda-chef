# Conda needs the .conda directory, the .conda/pkgs directory and the .conda/environments.txt file
# it is supposed to automatically create them, but it's very unpredictable when it comes to do so
# so we create them manually here


directory "/home/#{node['conda']['user']}/.conda" do
  user node['conda']['user']
  group node['conda']['group']
end

directory "/home/#{node['conda']['user']}/.conda/pkgs" do
  user node['conda']['user']
  group node['conda']['group']
end


file "/home/#{node['conda']['user']}/.conda/environments.txt" do
  user node['conda']['user']
  group node['conda']['group']
end


bash "update_conda" do
  user node['conda']['user']
  group node['conda']['group']
  environment ({'HOME' => "/home/#{node['conda']['user']}"})
  cwd "/home/#{node['conda']['user']}"
  retries 1
  retry_delay 10
  code <<-EOF
    #set -e
    #{node['conda']['base_dir']}/bin/conda update conda -y -q
    #{node['conda']['base_dir']}/bin/conda update anaconda -y -q
  EOF
end

#
# Install libraries into the root environment
#
for lib in node["conda"]["default_libs"] do
  bash "install_anconda_default_libs" do
    user node['conda']['user']
    group node['conda']['group']
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
  environment ({'HOME' => "/home/#{node['conda']['user']}"})
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    #{node['conda']['base_dir']}/bin/conda create -n #{node['conda']['user']}
  EOF
  not_if "test -d #{node['conda']['base_dir']}/envs/#{node['conda']['user']}", :user => node['conda']['user']
end

bash "create_hops-system_env" do
  user node['conda']['user']
  group node['conda']['group']
  environment ({'HOME' => "/home/#{node['conda']['user']}"})
  cwd "/home/#{node['conda']['user']}"
  code <<-EOF
    #{node['conda']['base_dir']}/bin/conda create -q -y -n hops-system python=2.7.15
    #{node['conda']['base_dir']}/envs/hops-system/bin/pip install -q --no-cache-dir --upgrade pip
    #{node['conda']['base_dir']}/envs/hops-system/bin/pip install -q --no-cache-dir pydoop==1.2.0
  EOF
  not_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end

bash "install_kagent_utils" do
  user 'root'
  group 'root'
  code <<-EOF
    #{node['conda']['base_dir']}/envs/hops-system/bin/pip install -q #{node["kagent"]["home"]}/kagent_utils
  EOF
  not_if "test -d #{node['conda']['base_dir']}/envs/hops-system", :user => node['conda']['user']
end
