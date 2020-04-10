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

          # Compilation
          it {
            is_expected.to compile
          }
        end
      end
    end
  end
end
