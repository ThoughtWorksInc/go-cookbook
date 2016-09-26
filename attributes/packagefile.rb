default['gocd']['install_method'] = 'package_file'
default['gocd']['download']['package_file']['baseurl'] = 'https://download.go.cd'

case node['gocd']['install_method']
when 'package_file'
	default['gocd']['version'] = '16.9.0'
end

version = node['gocd']['version']
os_dir = nil

case node['platform_family']
when 'debian'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.deb"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.deb"
  default['gocd']['package_file']['baseurl'] = node['gocd']['download']['baseurl']
  os_dir = 'deb'
when 'rhel', 'fedora'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.noarch.rpm"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.noarch.rpm"
  default['gocd']['package_file']['baseurl'] = node['gocd']['download']['baseurl']
  os_dir = 'rpm'
when 'windows'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}-setup.exe"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}-setup.exe"
  default['gocd']['package_file']['baseurl'] = node['gocd']['download']['baseurl']
  os_dir = 'win'
end

default['gocd']['server']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['server']['package_file']['filename'])
default['gocd']['server']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/binaries/#{version}/#{os_dir}/#{node['gocd']['server']['package_file']['filename']}"
default['gocd']['agent']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['agent']['package_file']['filename'])
default['gocd']['agent']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/binaries/#{version}/#{os_dir}/#{node['gocd']['agent']['package_file']['filename']}"
