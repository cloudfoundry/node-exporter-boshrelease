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
     describe 'node-exporter-key.pem' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/certs/node-exporter-key.pem.erb' }
          let(:expected_content) { "\n" }
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
     describe 'node-exporter-key.pem' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/certs/node-exporter-key.pem.erb' }
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {
                  'tls_server_config' => {
                    'key' => content
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
     describe 'node-exporter-cert.pem' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/certs/node-exporter-cert.pem.erb' }
          let(:expected_content) { "\n" }
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
     describe 'node-exporter-cert.pem' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/certs/node-exporter-cert.pem.erb' }
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {
                  'tls_server_config' => {
                    'cert' => content
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
     describe 'node-exporter-cacert.pem' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/certs/node-exporter-cacert.pem.erb' }
          let(:expected_content) { "\n" }
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
     describe 'node-exporter-cacert.pem' do
        it_should_behave_like 'a rendered file' do
          let(:file_name) { '../jobs/node_exporter/templates/certs/node-exporter-cacert.pem.erb' }
          let(:properties) do
            {
              'properties' => {
                'node_exporter' => {
                  'tls_server_config' => {
                    'ca_cert' => content
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
