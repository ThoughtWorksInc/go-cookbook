default['go']['backup_path'] = ''
default['go']['backup_retrieval_type'] = 'subversion'

default['go']['agent']['auto_register']         = false
default['go']['agent']['auto_register_key']     = 'default_auto_registration_key'
default['go']['agent']['auto_register_resources'] = []

# Install this many agent instances on a box - default is one per CPU

default['go']['agent']['instance_count'] = node['cpu']['total']
default['go']['agent']['server_search_query'] =
  "chef_environment:#{node.chef_environment} AND recipes'go'\\:\\:server"
  

default['go']['version']                       = '14.2.0-377'

unless platform?('windows')
  default['go']['agent']['java_home']             = '/usr/bin/java'
end


#set to old repo if version is 13
if node['go']['version'] =~ /13\./
	default['go']['apt_repository_url'] = 'http://download01.thoughtworks.com/go/debian'
	default['go']['apt_repository_components'] = ['contrib/']

	default['go']['yum_repository_url'] = 'http://download01.thoughtworks.com/go/yum/no-arch'
else 
	default['go']['apt_repository_url'] = 'http://download.go.cd/gocd-deb/'
	default['go']['apt_repository_components'] = ['/']

	default['go']['yum_repository_url'] = 'http://download.go.cd/gocd-rpm'
end

