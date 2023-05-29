require 'rspec'
require 'json'
require 'yaml'
require 'bosh/template/test'

describe 'node_exporter job' do
  let(:release) { Bosh::Template::Test::ReleaseDir.new(File.join(File.dirname(__FILE__), '..')) }
  let(:job) { release.job('node_exporter') }

  describe 'bin/node_exporter_ctl template' do
    let(:template) { job.template('bin/node_exporter_ctl') }
    let(:rendered_template) { template.render(properties) }
    let(:properties) do
      {
        'node_exporter' => {
          'collector' => {
            'ethtool' => {
              'enabled' => true
            }
          }
        }
      }
    end

    it 'renders with ethtool enabled' do
      expect(rendered_template).to include("--collector.ethtool")
    end
  end

  describe 'bin/node_exporter_ctl template' do
    let(:template) { job.template('bin/node_exporter_ctl') }
    let(:rendered_template) { template.render(properties) }
    let(:properties) do
      {
        'node_exporter' => {
          'collector' => {
            'dmi' => {
              'enabled' => false
            },
            'fibrechannel' => {
              'enabled' => false
            },
            'nvme' => {
              'enabled' => false
            },
            'os' => {
              'enabled' => false
            },
            'selinux' => {
              'enabled' => false
            },
            'tapestats' => {
              'enabled' => false
            }
          }
        }
      }
    end

    it 'renders with ethtool disabled' do
      expect(rendered_template).to include("--no-collector.dmi")
      expect(rendered_template).to include("--no-collector.fibrechannel")
      expect(rendered_template).to include("--no-collector.nvme")
      expect(rendered_template).to include("--no-collector.os")
      expect(rendered_template).to include("--no-collector.selinux")
      expect(rendered_template).to include("--no-collector.tapestats")
    end
  end

  describe 'bin/node_exporter_ctl template' do
    let(:template) { job.template('bin/node_exporter_ctl') }
    let(:rendered_template) { template.render(properties) }
    let(:properties) do
      {
        'node_exporter' => {
          'collector' => {
            'ethtool' => {
              'enabled' => false
            }
          }
        }
      }
    end

    it 'renders with ethtool disabled' do
      expect(rendered_template).to include("--no-collector.ethtool")
    end
  end

  describe 'bin/node_exporter_ctl template' do
    let(:template) { job.template('bin/node_exporter_ctl') }
    let(:rendered_template) { template.render(properties) }
    let(:properties) do
      {
        'node_exporter' => {
          'tls_server_config' => {
            'enabled' => true
          }
        }
      }
    end

    it 'renders with web-config enabled' do
      expect(rendered_template).to include("--web.config.file=/var/vcap/jobs/node_exporter/config/web-config.yml")
    end
  end

end
