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

      def add_host(response)
        host_name = response.args[2]
        host_address = response.args[3]

        if @@docker.add_host(host_name, host_address) then
          response.reply "Host #{host_name} added."
        else
          response.reply "Failed to add host #{host_name}."
        end
      end

      def list_hosts(response)
        host_list = @@docker.list_hosts
        if host_list.empty? then
          response.reply 'No Docker hosts connected.'
        else
          hosts = host_list.join("\n")
          response.reply "#{hosts}"
        end
      end

      def list_images(response)
        host_list = @@docker.list_hosts
        if host_list.empty? then
          response.reply 'No Docker hosts connected.'
        else
          reply_list = []

          host_list.each do |host|
            image_list = @@docker.list_images(host)
            if !image_list.empty?
              reply_list << host
              reply_list << image_list.map { |image| " • #{image}" }
            end
          end

          response.reply(reply_list.join("\n"))
        end
      end

      def list_containers(response)
        host_list = @@docker.list_hosts
        if host_list.empty? then
          response.reply 'No Docker hosts connected.'
        else
          reply_list = []

          host_list.each do |host|
            container_list = @@docker.list_containers(host)
            if !container_list.empty?
              reply_list << host
              reply_list << container_list.map { |container| " • #{container}" }
            end
          end
          response.reply(reply_list.join("\n"))
        end
      end
    end

    Lita.register_handler(Docker)
  end
end
