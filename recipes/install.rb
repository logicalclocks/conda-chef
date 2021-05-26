if node['kernel']['machine'] != 'x86_64'
   Chef::Log.fatal!("Unrecognized node.kernel.machine=#{node['kernel']['machine']}; Only x86_64", 1)
end

if node['platform_family'].eql?("rhel") && node['rhel']['epel'].downcase == "true"
  package "epel-release"
end

if node['platform_family'].eql?("rhel")
  package "bind-utils"
end

package ["bzip2", "vim", "iftop", "htop", "iotop", "rsync"]

group node['conda']['group']
user node['conda']['user'] do
  gid node['conda']['group']
  manage_home true
  home "/home/#{node['conda']['user']}"
  shell "/bin/bash"
  action :create
  system true
  not_if "getent passwd #{node['conda']['user']}"
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

directory node['install']['dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::File.directory?(node['install']['dir']) }
end

directory node['data']['dir'] do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
  not_if { ::File.directory?(node['data']['dir']) }
end

directory node['conda']['dir']  do
  owner node['conda']['user']
  group node['conda']['group']
  mode '755'
  recursive true
  action :create
  not_if { File.directory?(node['conda']['dir']) }
end

script = File.basename(node['conda']['url'])
installer_path = "#{Chef::Config[:file_cache_path]}/#{script}"

remote_file installer_path do
  source node['conda']['url']
#  checksum installer_checksum
  user node['conda']['user']
  group node['conda']['group']
  mode 0755
  action :create_if_missing
end

# Template condarc to set mirrors/channels
template "/home/#{node['conda']['user']}/.condarc" do
  source "condarc.erb"
  user node['conda']['user']
  group node['conda']['group']
  mode 0755
  variables({
    :pkgs_dirs => "#{node['conda']['base_dir']}/pkgs"
  })
end

# PIP mirror configuration
directory "/home/#{node['conda']['user']}/.pip" do
  user node['conda']['user']
  group node['conda']['group']
  action :create
end

template "/home/#{node['conda']['user']}/.pip/pip.conf" do
  source "pip.conf.erb"
  user node['conda']['user']
  group node['conda']['group']
  mode 0755
end

# Root because kagent env is installed as root
directory "/root/.pip" do
  user 'root'
  group 'root'
  action :create
end

template "/root/.pip/pip.conf" do
  source "pip.conf.erb"
  user "root"
  group "root"
  mode 0755
end

bash 'run_conda_installer' do
  user node['conda']['user']
  group node['conda']['group']
  umask "022"
  code <<-EOF
   #{installer_path} -b -p #{node['conda']['home']}
  EOF
  not_if { File.directory?(node['conda']['home']) }
end

link node['conda']['base_dir'] do
  owner node['conda']['user']
  group node['conda']['group']
  to node['conda']['home']
end

magic_shell_environment 'PATH' do
  value "$PATH:#{node['conda']['base_dir']}/bin"
end


ulimit_domain node['conda']['user'] do
  rule do
    item :nice
    type :hard
    value -10
  end
  rule do
    item :nice
    type :soft
    value -10
  end
end

if node[:conda][:channels].attribute?(:default_mirrors)
  conda_mirrors = node[:conda][:channels][:default_mirrors].split(",").map(&:strip)
else
  conda_mirrors = []
end

template "/home/#{node['conda']['user']}/hops-system-environment.yml" do
  source "hops-system-environment.yml.erb"
  user node['conda']['user']
  group node['conda']['group']
  mode 0750
  variables({
              :conda_mirrors => conda_mirrors
            })
end

template "/home/#{node['conda']['user']}/minimal-hops-system-environment.yml" do
  source "minimal-hops-system-environment.yml.erb"
  user node['conda']['user']
  group node['conda']['group']
  mode 0750
  variables({
              :conda_mirrors => conda_mirrors
            })
end

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