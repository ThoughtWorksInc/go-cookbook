require 'serverspec'

include Serverspec::Helper::Exec

describe "Go Agent Daemon" do

  it "has a running service of go-agent" do
    expect(service("go-agent")).to be_running
  end
end

describe "GO Agent Config" do 
  describe file('/var/lib/go-agent/config/autoregister.properties') do 
  	it {should be_file}
  	it {should be_readable}
  	it { should contain 'agent.auto.register.key=default_auto_registration_key' }
  end

describe file('/etc/default/go-agent') do 
  	it {should be_file}
  	it {should be_readable}
  	it { should contain 'GO Agent version 14.2.0-377' }
  end

end


