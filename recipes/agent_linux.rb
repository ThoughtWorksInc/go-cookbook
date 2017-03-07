include_recipe "gocd::agent_linux_install"

# use for instead of each because we need to name multiple agents based on number
(1..(node['gocd']['agent']['count'] - 1)).to_a.each do |i|
  name = "go-agent-#{i}"
  name = "go-agent" if i.zero?
  gocd_agent name
end
