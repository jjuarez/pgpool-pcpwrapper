require 'pgpool/node_info'

module PGPool
  #
  # = class: Response
  class Response
    OK      = 0
    UNKNOWN = 1  # Unknown Error (should not occur)
    EOF     = 2  # EOF Error
    NOMEM   = 3  # Memory shortage
    READ    = 4  # Error while reading from the server
    WRITE   = 5  # Error while writing to the server
    TIMEOUT = 6  # Timeout
    INVAL   = 7  # Argument(s) to the PCP command was invalid
    CONN    = 8  # Server connection error
    NOCONN  = 9  # No connection exists
    SOCK    = 10 # Socket error
    HOST    = 11 # Hostname resolution error
    BACKEND = 12 # PCP process error on the server
    AUTH    = 13 # Authorization failure

    ERROR_MESSAGES = {
      OK:      'No error',
      UNKNOWN: 'Unknown Error',
      EOF:     'EOF Error',
      NOMEM:   'Memory shortage',
      READ:    'Error while reading from the server',
      WRITE:   'Error while writing to the server',
      TIMEOUT: 'Timeout',
      INVAL:   'Argument(s) to the PCP command was invalid',
      CONN:    'Server connection error',
      NOCONN:  'No connection exists',
      SOCK:    'Socket error',
      HOST:    'Hostname resolution error',
      BACKEND: 'PCP process error on the server',
      AUTH:    'Authorization failure'
    }

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

    def error_message
      ERROR_MESSAGES[@status]
    end

    def to_hash
      { status: @status, node_info: @node_info }
    end

    def inspect
      to_hash.inspect
    end

    def to_s
      "#{inspect}"
    end
  end
end
