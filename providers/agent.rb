use_inline_resources

action :create do
  agent_name = new_resource.agent_name
  workspace = new_resource.workspace || "/var/lib/#{agent_name}"
  [workspace, "/var/log/#{agent_name}"].each do |d|
    directory d do
      mode     0755
      owner    new_resource.user
      group    new_resource.group
    end
  end
  directory "/var/lib/#{agent_name}/config" do
    mode     0700
    owner    new_resource.user
    group    new_resource.group
  end
  # package manages the init.d script so we will not
  # and we will expect that init.d scripts are already installed
  link "/etc/init.d/#{agent_name}" do
    to "/etc/init.d/go-agent"
    not_if { agent_name == 'go-agent' }
  end
  link "/usr/share/#{agent_name}" do
    to "/usr/share/go-agent"
    not_if { agent_name == 'go-agent' }
  end

  autoregister_values = get_chefserver_autoregister_values
  autoregister_values[:go_server_host] = new_resource.go_server_host || autoregister_values[:go_server_host]
  autoregister_values[:key] =  new_resource.autoregister_key || autoregister_values[:key]
  autoregister_values[:hostname] = new_resource.autoregister_hostname || autoregister_values[:hostname]
  autoregister_values[:environments] = new_resource.environments || autoregister_values[:environments]
  autoregister_values[:resources] = new_resource.resources || autoregister_values[:resources]

  template "/etc/default/#{agent_name}" do
    source   "go-agent-default.erb"
    mode     "0644"
    owner    "root"
    group    "root"
    notifies :restart,      "service[#{agent_name}]"
    variables autoregister_values
  end

  if autoregister_values[:key]
    template "/var/lib/#{agent_name}/config/autoregister.properties" do
      mode     "0644"
      owner    new_resource.user
      group    new_resource.group
      not_if { File.exists? ("/var/lib/#{agent_name}/config/agent.jks") }
      notifies :restart,      "service[#{agent_name}]"
      variables autoregister_values
    end
  end

  service agent_name do
    supports :status => true, :restart => true, :start => true, :stop => true
    action   new_resource.service_action
  end
end
