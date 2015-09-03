require 'pgpool/wrapper/node_info'

module PGPool
  module Wrapper

    #
    # = class: Response
    class Response
      OK        = 0
      UNKNOWN   = 1  # Unknown Error (should not occur)
      EOF       = 2  # EOF Error
      NOMEM     = 3  # Memory shortage
      READ      = 4  # Error while reading from the server
      WRITE     = 5  # Error while writing to the server
      TIMEOUT   = 6  # Timeout
      INVAL     = 7  # Argument(s) to the PCP command was invalid
      CONN      = 8  # Server connection error
      NOCONN    = 9  # No connection exists
      SOCK      = 10 # Socket error
      HOST      = 11 # Hostname resolution error
      BACKEND   = 12 # PCP process error on the server (specifying an invalid ID, etc.)
      AUTH      = 13 # Authorization failure

      attr_reader :status, :node_info

      def initialize(node_id, command)
        @status    = command.exitstatus
        @node_info = success? ? NodeInfo.build_from_raw_data(node_id, command.stdout) : command.stderr

        self
      end


      def success?
        status == OK
      end

      def error?
        status != OK
      end 
    end
  end
end