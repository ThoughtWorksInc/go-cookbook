##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

require 'spec_helper'

describe 'gocd_test::single_agent_lwrp' do
  context 'When all attributes are default' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
      stub_command("grep -q '# Provides: my-go-agent$' /etc/init.d/my-go-agent").and_return(false)
    end

    it_behaves_like :agent_linux_install

    it 'creates my-go-agent chef resource' do
      expect(chef_run).to create_gocd_agent('my-go-agent')
    end
    it 'does not create default go-agent chef resource' do
      expect(chef_run).to_not create_gocd_agent('go-agent')
    end

    it 'creates my-go-agent service' do
      expect(chef_run).to enable_service('my-go-agent')
      expect(chef_run).to start_service('my-go-agent')
    end

    it 'creates go agent configuration in /etc/default/my-go-agent' do
      expect(chef_run).to render_file('/etc/default/my-go-agent').with_content { |content|
        expect(content).to     include('GO_SERVER_URL=https://go.example.com:443/go')
        expect(content).to_not include('GO_SERVER_PORT')
        expect(content).to     include('AGENT_WORK_DIR=/mnt/big_drive')
        expect(content).to     include('DAEMON=Y')
        expect(content).to     include('VNC=Y')
      }
    end

    it 'creates autoregister properties file' do
      expect(chef_run).to create_gocd_agent_autoregister_file('/mnt/big_drive/config/autoregister.properties').with(
        autoregister_key: 'bla-key',
        autoregister_hostname: 'my-lwrp-agent',
        autoregister_environments: 'production',
        autoregister_resources: ['java-8', 'ruby-2.2']
      )
    end
  end
end
