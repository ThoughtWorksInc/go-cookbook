
server_ip = node['gocd']['agent']['server_host']
install_path = node['gocd']['agent']['install_path']

opts = ""
opts << "/SERVERIP=#{server_ip} " if node['gocd']['agent']['server_host']
opts << "/D=#{install_path}" if node['gocd']['agent']['install_path']

download_url = node['gocd']['agent']['download_url']
if !download_url
  major_ver = node['gocd']['version'].split('-', 2).first
  download_url = "http://download01.thoughtworks.com/go/#{major_ver}/ga/go-agent-#{node['gocd']['version']}-setup.exe"
end

windows_package 'Go Agent' do
  source download_url
  options opts
  action :install
end
