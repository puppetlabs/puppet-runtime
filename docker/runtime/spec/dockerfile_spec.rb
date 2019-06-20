require 'rspec/core'

describe 'puppet-agent runtime container' do
  include Pupperware::SpecHelpers

  before(:all) do
    @image = ENV['PUPPET_TEST_DOCKER_IMAGE']
    if @image.nil?
      error_message = <<-MSG
* * * * *
  PUPPET_TEST_DOCKER_IMAGE environment variable must be set so we
  know which image to test against!
* * * * *
      MSG
      fail error_message
    end
  end

  it 'should have ruby' do
    result = run_command("docker run #{@image} /opt/puppetlabs/puppet/bin/ruby --version")
    expect(result[:status]).to eq(0)
  end
end
