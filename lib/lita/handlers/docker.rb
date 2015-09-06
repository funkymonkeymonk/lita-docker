require "lita"
require_relative "docker_api_wrapper"

module Lita
  module Handlers
    class Docker < Handler
      @@docker = DockerApiWrapper.new

      route(/^list docker hosts/i, :list_hosts, command: true, help: {
        "list docker hosts" => "Lists accessable Docker hosts."
      })

      def list_hosts(response)
        host_list = @@docker.list
        if host_list.empty? then
          response.reply 'No Docker hosts connected.'
        else
          hosts = host_list.keys.join('\n')
          response.reply "#{hosts}"
        end
      end
    end

    Lita.register_handler(Docker)
  end
end
