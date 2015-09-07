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

  describe "#add_host" do
    context "with valid parameters" do
      it "adds a host" do
        host_name = 'test_host_1'
        host_address = 'tcp://192.168.99.100:2376'
        expect_any_instance_of(DockerApiWrapper).to receive(:add_host).and_return(true)
        send_command("docker add host #{host_name} #{host_address}")
        expect(replies.last).to match(/Host #{host_name} added\./)
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        host_name = 'test_host_1'
        host_address = 'tcp://192.168.99.100:2376'
        expect_any_instance_of(DockerApiWrapper).to receive(:add_host).and_return(false)
        send_command("docker add host #{host_name} #{host_address}")
        expect(replies.last).to match(/Failed to add host #{host_name}\./)
      end
    end
  end

  context "with no hosts added" do
    let(:hosts) { [] }
    describe "#list_hosts" do
      it "responds with no hosts attached" do
        expect_any_instance_of(DockerApiWrapper).to receive(:list_hosts).and_return(hosts)
        send_command("docker hosts")
        expect(replies.last).to match(/No Docker hosts connected\./)
      end
    end

    describe "#list_images" do
      it "responds with no hosts attached" do
        expect_any_instance_of(DockerApiWrapper).to receive(:list_hosts).and_return(hosts)
        send_command("docker images")
        expect(replies.last).to match(/No Docker hosts connected\./)
      end
    end

    describe "#list_containers" do
      it "responds with no hosts attached" do
        expect_any_instance_of(DockerApiWrapper).to receive(:list_hosts).and_return(hosts)
        send_command("docker containers")
        expect(replies.last).to match(/No Docker hosts connected\./)
      end
    end
  end

  context "with hosts added" do
    let(:hosts) { ['test_host_1', 'test_host_2', 'test_host_3'] }
    describe "#list_hosts" do
      it "responds with the name of each host attached" do
        expect_any_instance_of(DockerApiWrapper).to receive(:list_hosts).and_return(hosts)
        send_command("docker hosts")
        expect(replies.last).to match(hosts.join("\n"))
      end
    end

    describe "#list_images" do
      it "responds with a list of images on each host" do
        result1 = ['image1', 'image2']
        result2 = []
        result3 = ['image3']

        allow_any_instance_of(DockerApiWrapper).to receive(:list_hosts).and_return(hosts)
        allow_any_instance_of(DockerApiWrapper).to receive(:list_images).and_return(result1, result2, result3)

        send_command("docker images")
        expect(replies.last).to match("test_host_1\n" +
                                      " • image1\n" +
                                      " • image2\n" +
                                      "test_host_3\n"+
                                      " • image3")
      end
    end

    describe "#list_containers" do
      it "responds with running containers on each host" do
        result1 = ['org/container1', 'container2']
        result2 = []
        result3 = ['org2/container3']

        allow_any_instance_of(DockerApiWrapper).to receive(:list_hosts).and_return(hosts)
        allow_any_instance_of(DockerApiWrapper).to receive(:list_containers).and_return(result1, result2, result3)

        send_command("docker ps")
        expect(replies.last).to match("test_host_1\n" +
                                      " • org/container1\n" +
                                      " • container2\n" +
                                      "test_host_3\n"+
                                      " • org2/container3")
      end
    end
  end
end
