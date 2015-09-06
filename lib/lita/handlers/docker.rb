require "lita"
require_relative "docker_api_wrapper"

module Lita
  module Handlers
    class Docker < Handler
      @@docker = DockerApiWrapper.new

      route(/docker hosts/i, :list_hosts, command: true, help: {
        "docker hosts" => "Lists accessable Docker hosts."
      })

      route(/docker add host/i, :add_host, command: true, help: {
        "docker add host" => "Add a Docker host to the list of hosts."
      })

      route(/docker( all)? containers/i, :list_containers, command: true, help: {
        "docker containers" => "Lists Docker containers."
      })

      route(/docker ps( -a)?/i, :list_containers, command: true, help: {
        "docker ps" => "Lists Docker containers."
      })

      route(/docker images/i, :list_images, command: true, help: {
        "docker images" => "Lists Docker images."
      })


      def list_hosts(response)
        host_list = @@docker.list
        if host_list.empty? then
          response.reply 'No Docker hosts connected.'
        else
          hosts = host_list.keys.join("\n")
          response.reply "#{hosts}"
        end
      end

      def list_containers(response)
        return {}
      end

      def list_images(response)
        return {}
      end

      def add_host(response)
        return
      end
    end

    Lita.register_handler(Docker)
  end
end
