require 'forwardable'
require 'core_extensions/string/percentage'
require 'pgpool/command_launcher'
require 'pgpool/response'
require 'pgpool/node_info'
require 'pgpool/version'

#
# = module: PGPool module as namespace
module PGPool
  #
  # = class: PCPWrapper, the main gem module
  class PCPWrapper
    extend Forwardable

    DEFAULT_TIMEOUT  = 10
    DEFAULT_HOSTNAME = 'localhost'
    DEFAULT_PORT     = 9898
    DEFAULT_USER     = 'postgres'
    DEFAULT_PASSWORD = 'postgres'

    def_delegators :@command_launcher, :valid_node_id?, :node_information, :nodes_information

    def initialize(parameters={ })

      parameters = { 
        hostname: DEFAULT_HOSTNAME,
        port:     DEFAULT_PORT,
        user:     DEFAULT_USER,
        password: DEFAULT_PASSWORD,
        timeout:  DEFAULT_TIMEOUT
      }.merge(parameters)

      @command_launcher = CommandLauncher.new(
        parameters[:hostname],
        parameters[:port],
        parameters[:user],
        parameters[:password],
        parameters[:timeout])
      
      self
    end
  end
end
