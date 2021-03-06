module PGPool
  #
  # = class: NodeInfo, PORO
  class NodeInfo
    INITIALIZING      = 0 # This state is only used during the initialization.
    UP_NO_CONNECTIONS = 1 # Node is up. No connections yet.
    UP                = 2 # Node is up. Connections are pooled.
    DOWN              = 3 # Node is down.

    private

    def status=(status)
      fail("Invalid status: #{status}") unless [INITIALIZING, UP_NO_CONNECTIONS, UP, DOWN].include?(status)

      @status = status
    end

    public

    def self.build_from_raw_data(id, command_raw_data)
      hostname, port, status, weight = command_raw_data.split(' ')

      NodeInfo.new(id, hostname, port, status, weight)
    end

    attr_reader :id, :hostname, :port, :weight, :status

    def initialize(id, hostname, port, status, weight)
      @id         = id.to_i
      @hostname   = hostname
      @port       = port.to_i
      @weight     = weight.to_f

      self.status = status.to_i

      self
    end

    def initializing?
      status == INITIALIZING
    end

    def up?
      (status == UP || status == UP_NO_CONNECTIONS)
    end

    def down?
      status == DOWN
    end

    def to_hash
      { id: id, hostname: hostname, port: port, status: status, weight: weight }
    end

    def inspect
      to_hash.inspect
    end

    def to_s
      inspect
    end
  end
end
