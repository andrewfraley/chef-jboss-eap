
default['jboss-eap']['version'] = "6.1.1"
default['jboss-eap']['install_path'] = '/opt'
default['jboss-eap']['package_url'] = 'http://example.com/test'
default['jboss-eap']['checksum'] = 'derp'
default['jboss-eap']['log_dir'] = '/var/log/jboss'
default['jboss-eap']['jboss_user'] = 'jboss'
default['jboss-eap']['jboss_group'] = 'jboss'
default['jboss-eap']['admin_user'] = ''
default['jboss-eap']['admin_passwd'] = '' # Note the password has to be >= 8 characters, one numeric, one special
default['jboss-eap']['start_on_boot'] = false
