require 'spec_helper'
require 'pgpool/node_info'

describe PGPool::NodeInfo do
  before do
    @node_info_id     = 1
    @node_info_host   = 'backend1'
    @node_info_port   = 5432
    @node_info_status = 0
    @node_info_weight = 0.5
    @node_info        = PGPool::NodeInfo.build_from_raw_data(
      @node_info_id,
      "#{@node_info_host} #{@node_info_port} #{@node_info_status} #{@node_info_weight}")
  end

  it 'can be built from raw data' do
    expect(@node_info.class).to be PGPool::NodeInfo
    expect(@node_info.id.class).to be(Fixnum)
    expect(@node_info.id).to eq(@node_info_id)
    expect(@node_info.host.class).to be(String)
    expect(@node_info.host).to eq(@node_info_host)
    expect(@node_info.port.class).to be(Fixnum)
    expect(@node_info.port).to eq(@node_info_port)
    expect(@node_info.status.class).to be(Fixnum)
    expect(@node_info.status).to eq(@node_info_status)
    expect(@node_info.weight.class).to be(Float)
    expect(@node_info.weight).to eq(@node_info_weight)
  end

  it 'can be built from parameters' do
    expect(@node_info.class).to be(PGPool::NodeInfo)
    expect(@node_info.id.class).to be(Fixnum)
    expect(@node_info.id).to eq(@node_info_id)
    expect(@node_info.host.class).to be(String)
    expect(@node_info.host).to eq(@node_info_host)
    expect(@node_info.port.class).to be(Fixnum)
    expect(@node_info.port).to eq(@node_info_port)
    expect(@node_info.status.class).to be(Fixnum)
    expect(@node_info.status).to eq(@node_info_status)
    expect(@node_info.weight.class).to be(Float)
    expect(@node_info.weight).to eq(@node_info_weight)
  end

  it 'can be converted to a hash' do
    expect(@node_info.to_hash).to eq(id: @node_info_id, host: @node_info_host, port: @node_info_port, status: @node_info_status, weight: @node_info_weight)
  end

  it 'only admits valid status' do
    [PGPool::NodeInfo::INITIALIZING,
     PGPool::NodeInfo::UP_NO_CONNECTIONS,
     PGPool::NodeInfo::UP,
     PGPool::NodeInfo::DOWN].each do |status|
      expect(PGPool::NodeInfo.new(1, 'backend1', 5432, status, 0.5).class).to be(PGPool::NodeInfo)
    end
  end

  it 'does not admin unkown status values' do
    expect { PGPool::NodeInfo.new(1, 'backend1', 5432, 4, 0.5) }.to raise_error(RuntimeError)
  end

  it 'mark the node as initializing' do
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::INITIALIZING, 0.5).initializing?).to eq(true)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP_NO_CONNECTIONS, 0.5).initializing?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP, 0.5).initializing?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::DOWN, 0.5).initializing?).to eq(false)
  end

  it 'mark the node as up without connections' do
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::INITIALIZING, 0.5).up?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP_NO_CONNECTIONS, 0.5).up?).to eq(true)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP, 0.5).up?).to eq(true)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::DOWN, 0.5).up?).to eq(false)
  end

  it 'mark the node as up' do
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::INITIALIZING, 0.5).up?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP_NO_CONNECTIONS, 0.5).up?).to eq(true)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP, 0.5).up?).to eq(true)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::DOWN, 0.5).up?).to eq(false)
  end

  it 'mark the node as down' do
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::INITIALIZING, 0.5).down?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP_NO_CONNECTIONS, 0.5).down?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::UP, 0.5).down?).to eq(false)
    expect(PGPool::NodeInfo.new(1, 'backend1', 5432, PGPool::NodeInfo::DOWN, 0.5).down?).to eq(true)
  end
end
