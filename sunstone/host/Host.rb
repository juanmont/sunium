require './sunstone/Utils'

class Host

    def initialize(sunstone_test)
        @general_tag = "infrastructure"
        @resource_tag = "hosts"
        @datatable = "dataTableHosts"
        @sunstone_test = sunstone_test
        @utils = Utils.new(sunstone_test)
    end

    def create(json)
        @utils.navigate(@general_tag, @resource_tag)
        if !@utils.check_exists(2, json[:name], @datatable)
            @utils.navigate_create(@general_tag, @resource_tag)
            dropdown = @sunstone_test.get_element_by_id("host_type_mad")
            @sunstone_test.click_option(dropdown, "value", json[:type])
            @sunstone_test.get_element_by_id("name").send_keys json[:name]
            if json[:vmmad]
                @sunstone_test.get_element_by_name("custom_vmm_mad").send_keys json[:vmmad]
            end
            if json[:immad]
                @sunstone_test.get_element_by_name("custom_im_mad").send_keys json[:immad]
            end
            @utils.submit_create(@resource_tag)
        end
    end

    def check(name,hash={})
        @utils.navigate(@general_tag, @resource_tag)
        host = @utils.check_exists(2, name, @datatable)
        if host
            host.click
            div = @sunstone_test.get_element_by_id("host_info_tab")
            table = div.find_elements(:class, "dataTable")
            tr_table = table[0].find_elements(tag_name: 'tr')
            hash = @utils.check_elements(tr_table, hash)
            if !hash.empty?
                fail "Check fail: Not Found all keys"
                hash.each{ |obj| puts "#{obj[:key]} : #{obj[:key]}" }
            end
        end
    end

    def delete(name)
        @utils.delete_resource(name, @general_tag, @resource_tag, @datatable)
    end

    def update(name, new_name, json)
        @utils.navigate(@general_tag, @resource_tag)
        host = @utils.check_exists(2, name, @datatable)
        if host
            @utils.wait_jGrowl
            host.click
            @sunstone_test.get_element_by_id("host_info_tab-label")
            if new_name
                @utils.update_name(new_name)
            end
            if json[:cluster]
                span = @sunstone_test.get_element_by_id("#{@resource_tag}-tabmain_buttons")
                buttons = span.find_elements(:tag_name, "button")
                buttons[0].click
                tr = @utils.check_exists(1, json[:cluster], "confirm_with_select")
                if tr
                    tr.click
                else
                    fail "Cluster name: #{json[:cluster]} not exists"
                end
            end
            @utils.wait_jGrowl
            @sunstone_test.get_element_by_id("confirm_with_select_proceed").click
        else
            fail "Host name: #{name} not exists"
        end
    end

end
