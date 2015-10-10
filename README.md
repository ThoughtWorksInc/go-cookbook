# Go Cookbook

Hello friend! This cookbook is here to help you setup Go servers and agents
in an automated way.

It's primarily tested on newer versions of Ubuntu, but should work on both Debian and Red Hat based distributions.  There is also basic support for agents on Windows (enhancements appreciated!).

## Install method

### Repository

By default installation source is done from apt or yum repositories from official sources at http://www.go.cd/download/.

The **apt** repository can be overriden by changing any these attributes:
```ruby
default['gocd']['repository']['apt']['uri'] = 'http://download.go.cd/gocd-deb/'
default['gocd']['repository']['apt']['components'] = [ '/' ]
default['gocd']['repository']['apt']['package_options'] = '--force-yes'
default['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'
default['gocd']['repository']['apt']['key'] = '0x9149B0A6173454C7'
```
The **yum** repository can be overriden by changing any these attributes:
```ruby
default['gocd']['repository']['yum']['baseurl'] = 'http://download.go.cd/gocd-rpm'
default['gocd']['repository']['yum']['gpgcheck'] = false
```

### From remote file

Cookbook can skip adding repository and install Go server or agent by downloading a remote file and install it directly via `dpkg` or `rpm`.

Change install method to 'package_file':
```ruby
node['gocd']['install_method'] = 'remote_file'
```

And assign base url where packages are available for download
```ruby
node['gocd']['package_file']['baseurl'] = 'http://my/custom/url'
```
The final download URL of file is built based on platform and `node['gocd']['version']`. E.g. `http://my/custom/url/go-agent-15.2.0-2520.deb`

## Ideas

- How generic should we make this? All platforms or a handful?
- Test it with [test-kitchen](https://github.com/opscode/test-kitchen)? (Basic elements there)
- Can we enable pipeline configuration via chef?

# Go Server

go::server will install and start an empty Go server.

# Go Agent

## Linux
vagrant up command now requires ubuntu box name for older versions of vagrant (vagrant up ubuntu)
ubuntu is the default for newer versions

go::agent will install and configure a Go agent, and associate it with an existing Go server.  By default it will install one agent per CPU.  You can override this via node[:gocd][:agent][:instance_count].
### Single Node
go::default will install both on the same node for Linux OS.

## Windows

You can use Vagrant and your own chef bootstrapped virtual box base image and vagrant up windows

go recipe will install and configure a Windows Go agent on a Windows os, and associate it with an existing Go server.  Does not automatically register agent.

Overrides available for go::agent_windows
 * `node[:gocd][:agent][:server_host]` - hostname or ip of Go server
 * `node[:gocd][:agent][:install_path]` - installation path for Go agent
 * `node[:gocd][:agent][:java_home]` - java home path if using existing java installation
 * `node[:gocd][:agent][:download_url]` - msi for agent install, if left empty will build download url using `node[:gocd][:version]`


# Authors
Author:: Chris Kozak (<ckozak@gmail.com>)
Author:: Tim Brown (<tpbrown@gmail.com>)
