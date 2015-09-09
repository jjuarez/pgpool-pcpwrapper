require 'mixlib/shellout'
require 'pgpool/pcpwrapper/response'

module PGPool
  module PCPWrapper
    #
    # = class: CommandLauncher, a simple wrapper for PCP PGPool management CLI
    class CommandLauncher
      DEFAULT_TIMEOUT    = 10
      DEFAULT_PREFIX     = '/usr/sbin'
      PCP_NODE_COUNT_EXE = 'pcp_node_count'
      PCP_NODE_INFO_EXE  = 'pcp_node_info'
      INVALID_NODE_ID    = 99

      private

      def launch(command_str)
        command = ::Mixlib::ShellOut.new(command_str)

        command.run_command
        command.error!

        command
      end

      def extract_number_of_nodes
        launch(@pcp_node_count_command).to_i
      end

      public

      attr_reader :number_of_nodes

      def initialize(parameters)
        parameters              = { prefix: DEFAULT_PREFIX, timeout: DEFAULT_TIMEOUT }.merge(parameters)

        @hostname               = parameters[:hostname]
        @port                   = parameters[:port]
        @user                   = parameters[:user]
        @password               = parameters[:password]
        @timeout                = parameters[:timeout]
        @pcp_command_options    = "#{@timeout} #{@hostname} #{@port} #{@user} #{@password}"
        @pcp_node_count_command = "#{File.join(parameters[:prefix], PCP_NODE_COUNT_EXE)} #{@pcp_command_options}"
        @pcp_node_info_command  = "#{File.join(parameters[:prefix], PCP_NODE_INFO_EXE)} #{@pcp_command_options}"
        @number_of_nodes        = extract_number_of_nodes
        
        self
      end

      def valid_node_id?(node_id)
        node_id >= 0 && node_id < @number_of_nodes
      end

      def node_information(node_id)
        fail("Invalid node id(#{node_id}) must be between 0 and #{@number_of_nodes - 1}") unless valid_node_id?(node_id)
        Response.new(node_id, launch("#{@pcp_node_info_command} #{node_id}"))
      end

      def nodes_information
        @number_of_nodes.times.map { |node_id| node_information(node_id) }
      end
    end
  end
end
