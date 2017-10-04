require './sunstone/sunstone_test'
require './sunstone/vnet/VNet'

RSpec.describe "Network test" do

    before(:all) do

        @auth = {
            :username => "oneadmin",
            :password => "opennebula"
        }
        @sunstone_test = SunstoneTest.new(@auth)
        @sunstone_test.login
        @vnet = VNet.new(@sunstone_test)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    end

    after(:all) do
        @sunstone_test.sign_out
    end

    it "Create vnet" do
        @vnet.create("vnet1", "br0", "192.168.0.1", "100")
        @vnet.create("vnet2", "br0", "192.168.0.2", "100")
        @vnet.create("vnet3", "br0", "192.168.0.3", "100")
    end

end