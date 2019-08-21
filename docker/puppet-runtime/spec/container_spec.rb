require 'rspec/core'
require 'pupperware/spec_helper'
include Pupperware::SpecHelpers

describe 'puppet-agent runtime container' do
  before(:all) do
    @image = require_test_image
  end

  it 'should have ruby' do
    result = run_command("docker run --rm #{@image} /opt/puppetlabs/puppet/bin/ruby --version")
    expect(result[:status].exitstatus).to eq(0)
  end
end
