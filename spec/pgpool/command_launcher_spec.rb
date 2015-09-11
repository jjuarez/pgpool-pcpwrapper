require 'spec_helper'
require 'pgpool/command_launcher'

describe PGPool::CommandLauncher do
  before do
    @timeout  = 10
    @hostname = 'localhost'
    @port     = 9898
    @user     = 'postgres'
    @password = 'postgres'
    @node_id  = 0

    @pcp_node_info_command_1 = "/usr/sbin/pcp_node_info #{@timeout} #{@hostname} #{@port} #{@user} #{@password} #{@node_id}"
    @pcp_node_info_command_2 = "/usr/sbin/pcp_node_info #{@timeout} #{@hostname} #{@port} #{@user} #{@password} #{@node_id}"

    @up_status         = 2
    @down_status       = 3
    @backend0_id       = 0
    @backend0_hostname = 'backend0'
    @backend_port      = 5432
    @backend0_status   = @up_status
    @backend_weight    = 0.5
    @backend1_id       = 1
    @backend1_hostname = 'backend1'
    @backend1_status   = @down_status

    # Mixlib::Shellout mock
    @shellout_node_up = double('Mixlib::ShellOut', command: @pcp_node_info_command_1)
    allow(@shellout_node_up).to receive(:exitstatus) { 0 }
    allow(@shellout_node_up).to receive(:stdout) { "#{@backend0_hostname} #{@backend_port} #{@backend0_status} #{@backend_weight}" }

    #PGPool::NodeInfo success mock
    @pcp_node_info_successful = double('PGPool::NodeInfo', id: 0, command_raw_data: @shellout_node_up.stdout)
    allow(@pcp_node_info_successful).to receive(:id) { @backend0_id }
    allow(@pcp_node_info_successful).to receive(:hostname) { @backend0_hostname }
    allow(@pcp_node_info_successful).to receive(:port) { @backend_port }
    allow(@pcp_node_info_successful).to receive(:status) { @backend0_status }
    allow(@pcp_node_info_successful).to receive(:weight) { @backend_weight }

    @shellout_node_down = double('Mixlib::ShellOut', command: @pcp_node_info_command_2)
    allow(@shellout_node_down).to receive(:exitstatus) { 0 }
    allow(@shellout_node_down).to receive(:stdout) { "#{@backend1_hostname} #{@backend_port} #{@backend1_status} #{@backend_weight}" }

    #PGPool::NodeInfo failed mock
    @pcp_node_info_failed = double('PGPool::NodeInfo', id: @backend1_id, command_raw_data: @shellout_node_down.stdout) 
    allow(@pcp_node_info_failed).to receive(:id) { @backend1_id }
    allow(@pcp_node_info_failed).to receive(:hostname) { @backend1_hostname }
    allow(@pcp_node_info_failed).to receive(:port) { @backend_port }
    allow(@pcp_node_info_failed).to receive(:status) { @backend1_status }
    allow(@pcp_node_info_failed).to receive(:weight) { @backend_weight }

    # PGPool::CommandLauncher mock
    @number_of_nodes  = 2
    @command_launcher = double('PGPool::CommandLauncher', 
                               hostname: @hostname,
                               port: @port,
                               user: @user,
                               password: @password,
                               timeout: @timeout)

    allow(@command_launcher).to receive(:number_of_nodes) { @number_of_nodes }
    allow(@command_launcher).to receive(:valid_node_id?) { |id| id > -1 && id < @number_of_nodes }
    allow(@command_launcher).to receive(:node_info) { @pcp_node_info_successful } 
    allow(@command_launcher).to receive(:nodes_info) { [@pcp_node_info_successful, @pcp_node_info_failed] }
  end

  it 'can be built from parameters' do
    expect(PGPool::CommandLauncher.new(@hostname, @port, @user, @password, @timeout).class).to be PGPool::CommandLauncher
  end

  it 'can extract the number of backend nodes' do
    expect(@command_launcher.number_of_nodes).to eq(@number_of_nodes)
  end

  it 'can validate backend node ids' do
    expect(@command_launcher.valid_node_id?(0)).to eq(true)
    expect(@command_launcher.valid_node_id?(1)).to eq(true)
    expect(@command_launcher.valid_node_id?(2)).to eq(false)
  end

  it 'can retrieve the information for a backend node id' do
    expect(@command_launcher.node_info.id).to eq(0)
    expect(@command_launcher.node_info.hostname).to eq(@backend0_hostname)
    expect(@command_launcher.node_info.port).to eq(@backend_port)
    expect(@command_launcher.node_info.status).to eq(@up_status)
    expect(@command_launcher.node_info.weight).to eq(@backend_weight)
  end

  it 'can retrieve the information for all backend nodes' do
    expect(@command_launcher.nodes_info.class).to be(Array)
    expect(@command_launcher.nodes_info.length).to eq(@number_of_nodes)

    @number_of_nodes.times do |i| 
      expect(@command_launcher.nodes_info[i].id).to eq(i)
      expect(@command_launcher.nodes_info[i].hostname).to eq("backend#{i}")
      expect(@command_launcher.nodes_info[i].port).to eq(@backend_port)
      expect(@command_launcher.nodes_info[i].status).to be >= 0
      expect(@command_launcher.nodes_info[i].status).to be <= 3 
      expect(@command_launcher.nodes_info[i].weight).to eq(@backend_weight)
    end
  end
end
