require 'spec_helper'

describe PGPool::PCPWrapper::Response do
  before do
    @failed_command = Mixlib::ShellOut.new('/usr/bin/this_command_will_fail')

    @failed_command.run_command rescue RuntimeError

    @id      = 0
    @backend = 'backend1'
    @port    = 5432
    @status  = 2
    @weight  = 0.5

    @success_command = Mixlib::ShellOut.new("echo '#{@backend} #{@port} #{@status} #{@weight}'")
    @success_command.run_command rescue RuntimeError
  end

  it 'can be built from a Mixlib::ShellOut' do
    expect(PGPool::PCPWrapper::Response.new(@id, Mixlib::ShellOut.new('hostname')).class).to be(PGPool::PCPWrapper::Response)
  end

  it 'can handle failed commands' do
    response = PGPool::PCPWrapper::Response.new(@id, @failed_command)

    expect(response.class).to be(PGPool::PCPWrapper::Response)
    expect(response.status).not_to eq(PGPool::PCPWrapper::Response::OK)
    expect(response.success?).to eq(false)
  end

  it 'can take the stderr of a failed command' do
    response = PGPool::PCPWrapper::Response.new(@id, @failed_command)

    expect(response.class).to be(PGPool::PCPWrapper::Response)
    expect(response.node_info).to eq(@failed_command.stderr)
  end

  it 'can handle success commands' do
    response = PGPool::PCPWrapper::Response.new(@id, @success_command)

    expect(response.class).to be(PGPool::PCPWrapper::Response)
    expect(response.status).to eq(PGPool::PCPWrapper::Response::OK)
    expect(response.success?).to eq(true)
  end

  it 'can take the stdout of a success command' do
    response = PGPool::PCPWrapper::Response.new(@id, @success_command)

    expect(response.node_info.class).to be(PGPool::PCPWrapper::NodeInfo)
    expect(response.node_info.status).to eq(@status)
  end
end
