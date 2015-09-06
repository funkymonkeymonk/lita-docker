require "spec_helper"

describe Lita::Handlers::Docker, lita_handler: true do
  it { is_expected.to route_command("list docker hosts").to(:list_hosts) }

  describe "#list_hosts" do
    context "with no hosts connected" do
      it "responds with no hosts attached" do
        expect_any_instance_of(DockerApiWrapper).to receive(:list).and_return({})
        send_command("list docker hosts")
        expect(replies.last).to match(/No Docker hosts connected\./)
      end
    end

    context "with hosts connected" do
      it "responds with the name of each host attached" do
        results = {'test_host_1' => nil}
        expect_any_instance_of(DockerApiWrapper).to receive(:list).and_return(results)
        send_command("list docker hosts")
        expect(replies.last).to match('test_host_1')
      end
    end
  end
end
