require "spec_helper"

describe Lita::Handlers::Docker, lita_handler: true do

  describe "Lita Interface definition" do
    it { is_expected.to route_command("docker hosts").to(:list_hosts) }

    it { is_expected.to route_command("docker add host").to(:add_host) }

    it { is_expected.to route_command("docker ps").to(:list_containers) }
    it { is_expected.to route_command("docker ps -a").to(:list_containers) }
    it { is_expected.to route_command("docker ps on test_host_1").to(:list_containers) }
    it { is_expected.to route_command("docker ps -a on test_host_1").to(:list_containers) }

    it { is_expected.to route_command("docker containers").to(:list_containers) }
    it { is_expected.to route_command("docker all containers").to(:list_containers) }
    it { is_expected.to route_command("docker containers on test_host_1").to(:list_containers) }
    it { is_expected.to route_command("docker all containers on test_host_1").to(:list_containers) }

    it { is_expected.to route_command("docker images").to(:list_images) }
    it { is_expected.to route_command("docker images on test_host_1").to(:list_images) }
  end

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
        results = {'test_host_1' => nil, 'test_host_2' => nil}
        expect_any_instance_of(DockerApiWrapper).to receive(:list).and_return(results)
        send_command("list docker hosts")
        expect(replies.last).to match("test_host_1\ntest_host_2")
      end
    end
  end
end
