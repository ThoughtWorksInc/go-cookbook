require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Go Agent Daemon" do
  it "has a running service of go-agent" do
    expect(service("go-agent")).to be_running
  end
end

describe "GO Agent Config" do 
  describe file('/etc/default/go-agent') do 
  	it {should be_file}
  	it {should be_readable}
  	it { should contain 'GO Agent version 13.1.1-16714' }
  end
end

