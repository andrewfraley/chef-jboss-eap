#
# Cookbook Name:: jboss-eap
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

src_filename = "jboss-eap-v#{node['jboss-eap']['version']}.tar.gz"
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{node['jboss-eap']['install_path']}/jboss-eap-#{node['jboss-eap']['version']}"
jboss_user = node['jboss-eap']['jboss_user']
jboss_group = node['jboss-eap']['jboss_group']

#JBoss User
user node['jboss-eap']['jboss_user'] do
	action :create
end

remote_file src_filepath do
  source node['jboss-eap']['package_url']
  checksum node['jboss-eap']['checksum']
  owner 'root'
  group 'root'
  mode 00644
end

# Extract package to directory
bash 'extract_module' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path}
    mv #{extract_path}/*/* #{extract_path}/
    chown -R #{jboss_user}:#{jboss_group} #{extract_path}
    find #{extract_path}/ -exec chmod g+w {} \\;
    EOH
  not_if { ::File.exists?(extract_path) }
end

# Symlink jboss dir to versioned jboss dir
link "#{node['jboss-eap']['install_path']}/jboss" do
	to extract_path
end



# Init script config dir
directory "/etc/jboss-as" do
	owner 'root'
	group 'root'
	mode 00755
end

# Init script config file
template '/etc/jboss-as/jboss-as.conf' do
  source    'jboss-as.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
end

# Init script
cookbook_file "/etc/init.d/jboss" do
  source "jboss-as-standalone-init.sh"
  mode 0755
  owner "root"
  group "root"
end

# Delete log_dir if it's a symlink
link node['jboss-eap']['log_dir'] do
	action :delete
	only_if "test -h #{node['jboss-eap']['log_dir']}"
end

# Log directory
directory node['jboss-eap']['log_dir'] do
	owner node['jboss-eap']['jboss_user']
	group node['jboss-eap']['jboss_group']
	mode 0775
end

# Delete default log directory in prep for symlink
directory "#{node['jboss-eap']['install_path']}/jboss/standalone/log" do
	recursive true
	action :delete
	not_if { node['jboss-eap']['log_dir'] == "#{node['jboss-eap']['install_path']}/jboss/standalone/log" }
	not_if "test -h #{node['jboss-eap']['install_path']}/jboss/standalone/log"
end


# Log directory symlink
link "#{node['jboss-eap']['install_path']}/jboss/standalone/log" do
	to "#{node['jboss-eap']['log_dir']}"
	owner node['jboss-eap']['jboss_user']
	group node['jboss-eap']['jboss_group']
	not_if { node['jboss-eap']['log_dir'] == "#{node['jboss-eap']['install_path']}/jboss/standalone/log" }
	not_if "test -h #{node['jboss-eap']['install_path']}/jboss/standalone/log"
end

# Add admin user if the user is not found in mgmt-users.properties
execute "add_admin_user" do
	command "#{node['jboss-eap']['install_path']}/jboss/bin/add-user.sh --silent -u #{node['jboss-eap']['admin_user']} -p #{node['jboss-eap']['admin_passwd']}"
	not_if "grep #{node['jboss-eap']['admin_user']} #{node['jboss-eap']['install_path']}/jboss/standalone/configuration/mgmt-users.properties"
	not_if {node['jboss-eap']['admin_user'] == ''}
	not_if {node['jboss-eap']['admin_passwd'] == ''}
end

# Enable service on boot if requested
service "jboss" do
	if node['jboss-eap']['start_on_boot']
		action :enable
	else
		action :disable
	end
end



