require 'spec_helper'

describe 'storj' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      arch = os.split('-').last
      let(:facts) do
        os_facts.merge('os' => { 'architecture' => arch })
      end

      [
        {
          authorization_token: 'test.test@test.test:T3sT',
          wallet: '0x00000000',
          mail: 'test.test@test.test',
          host: 'test',
          storage: '1TB',
          storage_path: '/dev/null',
          version: '1.1.1',
          manage_docker: false,
        },
      ].each do |parameters|
        context "with parameters #{parameters}" do
          let(:params) do
            parameters
          end

          s_os = os_facts[:kernel].downcase

          s_arch = case os_facts[:architecture]
                   when 'aarch64'
                     'arm64'
                   when 'armv7l'
                     'arm'
                   else
                     'amd64'
                   end

          authorization_token = parameters[:authorization_token]
          wallet = parameters[:wallet]
          mail = parameters[:mail]
          host = parameters[:host]
          storage = parameters[:storage]
          storage_path = parameters[:storage_path]
          version = parameters[:version]
          base_dir = parameters[:base_dir] || '/opt'
          bin_dir = parameters[:bin_dir] || '/usr/local/bin'
          base_url = parameters[:base_url] || 'https://github.com/storj/storj/releases/download'
          download_extension = parameters[:download_extension] || 'zip'
          download_url = parameters[:download_url] || "#{base_url}/v#{version}/identity_#{s_os}_#{s_arch}.#{download_extension}"
          extract_command = parameters[:extract_command] || nil
          config_dir = parameters[:config_dir] || '/etc/storj'
          manage_user = parameters[:manage_user].nil? ? true : parameters[:manage_user]
          manage_group = parameters[:manage_group].nil? ? true : parameters[:manage_group]
          user = parameters[:user] || 'storj'
          group = parameters[:group] || 'storj'
          user_shell = parameters[:user_shell] || '/bin/false'
          extra_groups = parameters[:extra_groups] || []
          service_ensure = parameters[:service_ensure] || 'running'
          docker_tag = parameters[:docker_tag] || 'beta'
          port = parameters[:port] || 28_967
          dashboard_port = parameters[:dashboard_port] || 14_002
          manage_docker = parameters[:manage_docker].nil? ? true : parameters[:manage_docker]

          case service_ensure
          when 'running'
            file_ensure = 'file'
            service_ensure = 'running'
          when 'stopped'
            file_ensure = 'file'
            service_ensure = 'stopped'
          else
            file_ensure = 'absent'
            service_ensure = 'stopped'
          end

          # Compilation
          it {
            is_expected.to compile
          }

          # Implementation
          it {
            is_expected.to contain_class('storj::install')
            is_expected.to contain_class('storj::config')
            is_expected.to contain_class('storj::service')

            if manage_docker
              is_expected.to contain_class('docker')
            else
              is_expected.not_to contain_class('docker')
            end
          }

          # Install
          it {
            is_expected.to contain_file("#{base_dir}/storj-#{version}.#{s_os}-#{s_arch}").with(
              'ensure' => 'directory',
              'owner'  => 'root',
              'group'  => '0',
              'mode'   => '0755',
            )
            is_expected.to contain_archive("/tmp/identity_#{version}.#{download_extension}").with(
              'ensure'          => 'present',
              'extract'         => true,
              'extract_path'    => "#{base_dir}/storj-#{version}.#{s_os}-#{s_arch}",
              'source'          => download_url,
              'checksum_verify' => false,
              'creates'         => "#{base_dir}/storj-#{version}.#{s_os}-#{s_arch}/identity",
              'cleanup'         => true,
              'extract_command' => extract_command,
            )
            is_expected.to contain_file("#{base_dir}/storj-#{version}.#{s_os}-#{s_arch}/identity").with(
              'owner'  => 'root',
              'group'  => '0',
              'mode'   => '0555',
            )
            is_expected.to contain_file("#{bin_dir}/identity").with(
              'ensure' => 'link',
              'target' => "#{base_dir}/storj-#{version}.#{s_os}-#{s_arch}/identity",
            )

            # User
            if manage_user
              is_expected.to contain_user(user).with(
                'ensure' => 'present',
                'system' => true,
                'groups' => [group, 'docker'] + extra_groups,
                'shell'  => user_shell,
              )
            else
              is_expected.not_to contain_user(user)
            end
            # Group
            if manage_group
              is_expected.to contain_group(group).with(
                'ensure' => 'present',
                'system' => true,
              )
            else
              is_expected.not_to contain_group(group)
            end

            is_expected.to contain_file(config_dir).with(
              'ensure'  => 'directory',
              'owner'   => user,
              'group'   => group,
            )
          }

          # Config
          it {
            is_expected.to contain_exec('Request authorization command').with(
              'command'   => "#{bin_dir}/identity authorize storagenode #{authorization_token} --identity-dir #{config_dir} --config-dir #{config_dir}",
              'onlyif'    => "/usr/bin/test `grep -c BEGIN #{config_dir}/storagenode/identity.cert` != 3",
              'user'      => group,
              'group'     => user,
              'logoutput' => true,
            ).that_notifies('Service[storagenode]')

            is_expected.to contain_exec('Check certs integrity command').with(
              'command'   => "/usr/bin/test `grep -c BEGIN #{config_dir}/storagenode/ca.cert` == 2 &&
                  /usr/bin/test `grep -c BEGIN #{config_dir}/storagenode/identity.cert` == 3",
              'logoutput' => true,
              'returns'   => 0,
            )
          }

          # Service
          it {
            is_expected.to contain_file('/lib/systemd/system/storagenode.service').with(
              'ensure' => file_ensure,
            ).with_content(
              "# THIS FILE IS MANAGED BY PUPPET
[Unit]
Description=Storj storagenode service
BindsTo=docker.service
After=docker.service

[Service]
User=#{user}
Group=#{group}
Environment=NAME=storagenode
Restart=on-failure
RestartSec=10
ExecStartPre=-/usr/bin/docker kill ${NAME}
ExecStartPre=-/usr/bin/docker rm ${NAME}
ExecStart=/usr/bin/docker run --name ${NAME} \\
--stop-timeout 300 \\
-p #{port}:28967 \\
-p #{dashboard_port}:14002 \\
-e WALLET=\"#{wallet}\" \\
-e EMAIL=\"#{mail}\" \\
-e ADDRESS=\"#{host}:#{port}\" \\
-e STORAGE=\"#{storage}\" \\
--mount type=bind,source=\"#{config_dir}/storagenode\",destination=/app/identity \\
--mount type=bind,source=\"#{storage_path}\",destination=/app/config \\
storjlabs/storagenode:#{docker_tag}
ExecStop=/usr/bin/docker stop ${NAME}

[Install]
WantedBy=multi-user.target
",
            ).that_notifies('Service[storagenode]')

            is_expected.to contain_service('storagenode').with(
              'ensure' => service_ensure,
              'enable' => true,
            )
          }
        end
      end
    end
  end
end
