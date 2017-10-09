require './sunstone/sunstone_test'
require './sunstone/vnet/VNet'

RSpec.describe "Network test" do

    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "mypassword"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @vnet = VNet.new(@sunstone_test)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create vnet" do
        @vnet.create("vnet1", "br0", "192.168.0.1", "100")
    end

    it "Check vnet" do
        hash_info = [ {key: "BRIDGE", value: "br0"} ]
        ars = [
            {IP: "192.168.0.1", SIZE: "100"}
        ]

        @vnet.check("vnet1", hash_info, ars)
    end

    it "Delete vnet" do
        @vnet.delete("vnet1")
    end

    it "Update vnet" do
        @vnet.update("vnet1", "br1", "dummy")
    end

end