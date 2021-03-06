require './sunstone/sunstone_test'
require './sunstone/host/Host'
require './sunstone/cluster/Cluster'

RSpec.describe "Host test" do

    before(:all) do
        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @cluster = Cluster.new(@sunstone_test)
        @host = Host.new(@sunstone_test)
    end

    before(:each) do
        sleep 1
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create two hosts (dummy and kvm)" do
        hash = { name: "test1_dummy", type: "custom", vmmad: "dummy", immad: "dummy"}
        @host.create(hash)
        hash = { name: "test1_kvm", type: "kvm" }
        @host.create(hash)
    end

    it "Check hosts" do
        hash=[
            {key:"IM MAD", value:"kvm"},
            {key:"VM MAD", value:"kvm"}
        ]
        @host.check("test1_kvm", hash)

        hash=[
            {key:"IM MAD", value:"dummy"},
            {key:"VM MAD", value:"dummy"}
        ]
        @host.check("test1_dummy", hash)
    end

    it "Update host" do
        @cluster.create("test_cl_host", [], [], [])
        hash = { cluster: "test_cl_host" }
        @host.update("test1_dummy", "host_2", hash)
    end

    it "Delete hosts" do
        @host.delete("host_2")
      @host.delete("test1_kvm")
    end

end