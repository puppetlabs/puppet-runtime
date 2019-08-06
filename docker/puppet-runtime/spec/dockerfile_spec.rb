require 'rspec/core'

describe 'puppet-agent runtime container' do
  include Pupperware::SpecHelpers

  before(:all) do
    @image = require_test_image
  end

  it 'should have ruby' do
    result = run_command("docker run #{@image} /opt/puppetlabs/puppet/bin/ruby --version")
    expect(result[:status]).to eq(0)
  end
end
