require 'rspec'
require 'json'
require 'yaml'
require 'bosh/template/test'
require 'bosh/template/evaluation_context'
require_relative './template_example_group'

describe 'node_exporter job' do
  let(:release) { Bosh::Template::Test::ReleaseDir.new(File.join(File.dirname(__FILE__), '..')) }
  let(:job) { release.job('node_exporter') }
  let(:properties) { default_properties }
  let(:default_properties) do
    {
      'node_exporter' => {
        'collectors' => {
          'ethtool' => {
            'enabled' => true
          }
        }
      }
    }
  end

  describe 'node-exporter' do
    describe 'tls-server-config' do
      describe 'web-config.yml' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/config/web-config.yml.erb' }
          let(:expected_content) do
            <<~HEREDOC
#ref: https://github.com/prometheus/exporter-toolkit/blob/v0.1.0/https/README.md
---
tls_server_config:
  cert_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-cert.pem"
  key_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-key.pem"

            HEREDOC
          end
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {}
              }
            }
          end
        end
      end
    end
  end

  describe 'node-exporter' do
    describe 'tls-server-config' do
      describe 'web-config.yml' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/config/web-config.yml.erb' }
          let(:expected_content) do
            <<~HEREDOC
#ref: https://github.com/prometheus/exporter-toolkit/blob/v0.1.0/https/README.md
---
tls_server_config:
  cert_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-cert.pem"
  key_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-key.pem"

            HEREDOC
          end
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {
                  'tls_server_config' => {
                    'enabled' => false
                  }
                }
              }
            }
          end
        end
      end
    end
  end

  describe 'node-exporter' do
    describe 'tls-server-config' do
      describe 'web-config.yml' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/config/web-config.yml.erb' }
          let(:expected_content) do
            <<~HEREDOC
#ref: https://github.com/prometheus/exporter-toolkit/blob/v0.1.0/https/README.md
---
tls_server_config:
  cert_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-cert.pem"
  key_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-key.pem"
  client_ca_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-cacert.pem"
  client_auth_type: maybe
  min_version: bb
  max_version: aa
  cipher_suites:
  - a
  - b
  - c
  prefer_server_cipher_suites: true
  curve_preferences:
  - d
  - e
  - f
http_server_config:
  http2: true

            HEREDOC
          end
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {
                  'tls_server_config' => {
                    'enabled' => true,
                    'cert' => 'cert',
                    'key' => 'key',
                    'client_auth_type' => 'maybe',
                    'ca_cert' => 'ca_cert',
                    'min_tls' => 'bb',
                    'max_tls' => 'aa',
                    'ciphers' => 'a,b,c',
                    'ciphers_prefer_server' => true,
                    'curves' => 'd,e,f'
                  },
                  'http_server_config' => {
                    'http2_enabled' => true
                  }
                }
              }
            }
          end
        end
      end
    end
  end

  describe 'node-exporter' do
    describe 'tls-server-config' do
      describe 'web-config.yml' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/config/web-config.yml.erb' }
          let(:expected_content) do
            <<~HEREDOC
#ref: https://github.com/prometheus/exporter-toolkit/blob/v0.1.0/https/README.md
---
tls_server_config:
  cert_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-cert.pem"
  key_file: "/var/vcap/jobs/node_exporter/certs/node-exporter-key.pem"

            HEREDOC
          end
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {
                  'tls_server_config' => {
                    'enabled' => true,
                    'cert' => 'cert',
                    'key' => 'key',
                  }
                }
              }
            }
          end
        end
      end
    end
  end

end
