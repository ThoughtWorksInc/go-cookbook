default['gocd']['backup_path'] = ''
default['gocd']['backup_retrieval_type'] = 'subversion'

default['gocd']['agent']['auto_register']         = false
default['gocd']['agent']['auto_register_key']     = 'default_auto_registration_key'
default['gocd']['agent']['auto_register_resources'] = []
default['gocd']['agent']['auto_register_environments'] = []

# Install this many agent instances on a box - default is one per CPU

default['gocd']['agent']['instance_count'] = node['cpu']['total']
default['gocd']['agent']['server_search_query'] =
  "chef_environment:#{node.chef_environment} AND recipes:go\\:\\:server"


default['gocd']['version']                          = '15.2.0-2248'
force_default['java']['jdk_version']  = '7'

unless platform?('windows')
  default['gocd']['agent']['java_home']             = '/usr/bin/java'
  default['gocd']['agent']['work_dir_path']         = '/var/lib'
end

default['gocd']['server']['install_path'] = 'C:\Program Files (x86)\Go Server'

default['gocd']['install_method'] = 'repository'

default['gocd']['repository']['apt']['uri'] = 'http://download.go.cd/gocd-deb/'
default['gocd']['repository']['apt']['components'] = [ '/' ]
default['gocd']['repository']['apt']['package_options'] = '--force-yes'
default['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'
default['gocd']['repository']['apt']['key'] = '0x9149B0A6173454C7'

default['gocd']['repository']['yum']['baseurl'] = 'http://download.go.cd/gocd-rpm'
default['gocd']['repository']['yum']['gpgcheck'] = false

version = node['gocd']['version']
case node['platform_family']
when 'debian'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.deb"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.deb"
  default['gocd']['package_file']['baseurl'] = 'http://download.go.cd/gocd-deb/'
when 'rhel','fedora'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.noarch.rpm"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.noarch.rpm"
  default['gocd']['package_file']['baseurl'] = 'http://download.go.cd/gocd-rpm/'
end

default['gocd']['server']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['server']['package_file']['filename'])
default['gocd']['server']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/#{node['gocd']['server']['package_file']['filename']}"
default['gocd']['agent']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['agent']['package_file']['filename'])
default['gocd']['agent']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/#{node['gocd']['agent']['package_file']['filename']}"
