module PGPool
  module Wrapper
    #
    # = class: NodeInfo, PORO
    class NodeInfo
      INITIALIZING      = 0 # This state is only used during the initialization.
      UP_NO_CONNECTIONS = 1 # Node is up. No connections yet.
      UP                = 2 # Node is up. Connections are pooled.
      DOWN              = 3 # Node is down.


      def self.build_from_raw_data(id, command_raw_data)
        host, port, status, weight = command_raw_data.split(' ')

        NodeInfo.new(id, host, port, weight, status)
      end

      attr_reader :id, :host, :port, :weight, :status

      def initialize(id, host, port, weight, status)
        @id     = id
        @host   = host
        @port   = port.to_i
        @weight = weight.to_f
        @status = status.to_i

        self
      end

      def up?
        (status == UP || status == UP_NO_CONNECTIONS)
      end

      def down?
        status == DOWN
      end

      def inspect
        "{ id: #{id}, host: #{host}, port: #{port}, weight: #{weight}, status: #{status} }"
      end

      def to_s
        inspect
      end
    end
  end
end