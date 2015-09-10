require 'spec_helper'
require 'pgpool/command_launcher'

describe PGPool::CommandLauncher do
  before do
    @hostname                  = 'locahost'
    @port                      = 1234
    @user                      = 'user'
    @password                  = 'password'
    @timeout                   = 10
    @standard_command_launcher = PGPool::CommandLauncher.new(@hostname, @port, @user, @password, @timeout)
    @number_of_nodes           = 2

    @command_launcher = double("PGPool::CommandLauncher", 
                                hostname: @hostname, 
                                port: @port, 
                                user: @user, 
                                password: @password, 
                                timeout: @timeout)

    allow(@command_launcher).to receive(:number_of_nodes).and_return(@number_of_nodes)
    allow(@command_launcher).to receive(:valid_node_id?).and_return(true)
  end

  it 'can be built from parameters' do
    expect(@standard_command_launcher.class).to be PGPool::CommandLauncher
  end

  it 'can extract the number of backend nodes' do
    expect(@command_launcher.number_of_nodes).to eq(@number_of_nodes)
  end

  it 'can validate backend node ids' do
    expect(@command_launcher.valid_node_id?(0)).to eq(true)
    expect(@command_launcher.valid_node_id?(1)).to eq(true)
  end

  it 'can retrieve the information for a backend node id' do
    expect(@command_launcher.valid_node_id?(2)).to eq(false)
  end

  it 'can retrieve the information for all backend nodes' do
    fail("You need to implement this expectation")
  end
end
