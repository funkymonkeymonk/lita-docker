require "spec_helper"

describe Lita::Handlers::Docker, lita_handler: true do
  it { is_expected.to route_command("list docker hosts").to(:list_hosts) }

  describe "#list_hosts" do
    it "responds with no hosts attached" do
      send_command("list docker hosts")
      expect(replies.last).to match(/No Docker hosts connected\./)
    end
  end
end
