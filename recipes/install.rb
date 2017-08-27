if node["kernel"]["machine"] != 'x86_64'
   Chef::Log.fatal!("Unrecognized node.kernel.machine=#{node["kernel"]["machine"]}; Only x86_64", 1)
end

group node["conda"]["group"]
user node["conda"]["user"] do
  gid node["conda"]["group"]
  manage_home true
  home "/home/#{node["conda"]["user"]}"
  shell "/bin/bash"
  action :create  
  not_if "getent passwd #{node["conda"]["user"]}"
end

directory node["conda"]["dir"]  do
  owner node["conda"]["user"]
  group node["conda"]["group"]
  mode "755"
  action :create
  not_if { File.directory?("#{node["conda.dir"]}") }
end


script = File.basename(node["conda"]["url"])
installer_path = "#{Chef::Config[:file_cache_path]}/#{script}"
  
remote_file installer_path do
  source node["conda"]["url"]
#  checksum installer_checksum
  user node["conda"]["user"]
  group node["conda"]["group"]
  mode 0755
  action :create_if_missing
end

bash 'run_conda_installer' do
  user node["conda"]["user"]
  group node["conda"]["group"]
  code <<-EOF
   #{installer_path} -b -p #{node["conda"]["home"]}
  EOF
  not_if { File.directory?(node["conda"]["home"]) }
end


link node["conda"]["base_dir"] do
  owner node["conda"]["user"]
  group node["conda"]["group"]
  to node["conda"]["home"]
end


magic_shell_environment 'PATH' do
  value "$PATH:#{node["conda"]["base_dir"]}/bin"
end
