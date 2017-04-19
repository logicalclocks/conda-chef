
include_recipe "apache2"

# apache_conf 'webserver' do
#   enable true
# end


web_app "conda_repo" do
  server_name node['hostname']
  server_aliases [node['fqdn'], "conda.repo"]
  docroot "/var/www/conda_repo"
  cookbook 'apache2'
end


# /my-conda-channel/linux-64

directory "/var/www/conda_repo/hops/linux-64"  do
  owner node["conda"]["user"]
  group node["conda"]["group"]
  mode "755"
  action :create
  recursive true
end
