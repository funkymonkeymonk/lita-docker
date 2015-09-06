require "lita"

module Lita
  module Handlers
    class Docker < Handler
      route(/^list docker hosts/i, :list_hosts, command: true, help: {
        "flip a coin" => "Flips a coin and tells you the results."
      })

      def list_hosts(response)
        response.reply 'No Docker hosts connected.'
      end
    end

    Lita.register_handler(Docker)
  end
end
