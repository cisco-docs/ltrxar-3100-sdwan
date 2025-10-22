class Rule:
    id = "404"
    description = "Features required parameters"
    severity = "HIGH"

    #########################################################################################################################################
    # In UX 2.0 features, some parameters have no default value and are required to be set as global or as variable.
    # This rule checks if the required parameters are set in the features.
    # For any additional parameters where this validation is required, add the path to the required parameter in the paths
    # (use global value as variable value is automatically checked). No additional code changes should be required
    #########################################################################################################################################

    paths = [
        "sdwan.feature_profiles.other_profiles.thousandeyes.account_group_token",
        "sdwan.feature_profiles.other_profiles.ucse.cimc_ipv4_address",
        "sdwan.feature_profiles.other_profiles.ucse.interfaces.ipv4_address",
        "sdwan.feature_profiles.service_profiles.ipv4_trackers.tracker_name",
        "sdwan.feature_profiles.service_profiles.object_tracker_groups.id",
        "sdwan.feature_profiles.service_profiles.object_trackers.id",
        "sdwan.feature_profiles.service_profiles.dhcp_servers.pool_network_address",
        "sdwan.feature_profiles.service_profiles.dhcp_servers.pool_subnet_mask",
        "sdwan.feature_profiles.service_profiles.dhcp_servers.static_leases.ip_address",
        "sdwan.feature_profiles.service_profiles.dhcp_servers.static_leases.mac_address",   
        "sdwan.feature_profiles.service_profiles.dhcp_servers.options.code",               
        "sdwan.feature_profiles.system_profiles.aaa.users.name",
        "sdwan.feature_profiles.system_profiles.aaa.users.password",
        "sdwan.feature_profiles.system_profiles.bfd.colors.color",
        "sdwan.feature_profiles.system_profiles.logging.ipv4_servers.hostname_ip",
        "sdwan.feature_profiles.system_profiles.logging.ipv6_servers.hostname_ip",
        "sdwan.feature_profiles.system_profiles.logging.tls_profiles.name",
        "sdwan.feature_profiles.system_profiles.ntp.authentication_keys.id",
        "sdwan.feature_profiles.system_profiles.ntp.authentication_keys.md5_value",
        "sdwan.feature_profiles.system_profiles.ntp.servers.hostname_ip",
        "sdwan.feature_profiles.system_profiles.security.integrity_types",
        "sdwan.feature_profiles.system_profiles.security.keys.key_string",
        "sdwan.feature_profiles.system_profiles.security.keys.receiver_id",
        "sdwan.feature_profiles.system_profiles.security.keys.send_id",
        "sdwan.feature_profiles.system_profiles.snmp.communities.authorization",
        "sdwan.feature_profiles.system_profiles.snmp.communities.view",
        "sdwan.feature_profiles.system_profiles.snmp.groups.view",
        "sdwan.feature_profiles.system_profiles.snmp.trap_target_servers.ip",
        "sdwan.feature_profiles.system_profiles.snmp.trap_target_servers.port",
        "sdwan.feature_profiles.system_profiles.snmp.trap_target_servers.source_interface",
        "sdwan.feature_profiles.system_profiles.snmp.trap_target_servers.vpn_id",
        "sdwan.feature_profiles.system_profiles.snmp.users.group",
        "sdwan.feature_profiles.system_profiles.snmp.views.oids.id",
        "sdwan.feature_profiles.transport_profiles.ipv4_trackers.tracker_name",
        "sdwan.feature_profiles.transport_profiles.ipv6_tracker_groups.tracker_name",
        "sdwan.feature_profiles.transport_profiles.ipv6_trackers.tracker_name",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ethernet_interfaces.arp_entries.ip_address",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ethernet_interfaces.arp_entries.mac_address",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ethernet_interfaces.interface_name",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ethernet_interfaces.ipv4_secondary_addresses.address",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ethernet_interfaces.ipv4_secondary_addresses.subnet_mask",
        "sdwan.feature_profiles.transport_profiles.management_vpn.host_mappings.hostname",
        "sdwan.feature_profiles.transport_profiles.management_vpn.host_mappings.ips",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ipv4_static_routes.network_address",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ipv4_static_routes.subnet_mask",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ipv4_static_routes.next_hops.address",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ipv6_static_routes.prefix",
        "sdwan.feature_profiles.transport_profiles.management_vpn.ipv6_static_routes.next_hops.address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.adaptive_qos_shaping_rate_downstream.default",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.adaptive_qos_shaping_rate_downstream.maximum",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.adaptive_qos_shaping_rate_downstream.minimum",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.adaptive_qos_shaping_rate_upstream.default",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.adaptive_qos_shaping_rate_upstream.maximum",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.adaptive_qos_shaping_rate_upstream.minimum",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.arp_entries.ip_address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.arp_entries.mac_address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.interface_name",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.ipv4_nat_static_entries.source_ip",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.ipv4_nat_static_entries.translate_ip",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.ipv4_secondary_addresses.address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.ipv4_secondary_addresses.subnet_mask",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.ipv6_nat66_static_entries.source_prefix",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces.ipv6_nat66_static_entries.translate_prefix",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.host_mappings.hostname",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.host_mappings.ips",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ipv4_static_routes.network_address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ipv4_static_routes.subnet_mask",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ipv4_static_routes.next_hops.address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ipv6_static_routes.prefix",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.ipv6_static_routes.next_hops.address",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.nat_64_v4_pools.name",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.nat_64_v4_pools.range_start",
        "sdwan.feature_profiles.transport_profiles.wan_vpn.nat_64_v4_pools.range_end",
    ]

    @classmethod
    def match_path(cls, inventory, full_path, search_path):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        if len(path_elements) == 1:
            # Verify if element or element_variable exists in the path
            global_value = path_elements[0]
            variable_value = global_value + "_variable"
            if global_value not in inv_element and variable_value not in inv_element:
                results.append(f"Required parameter {global_value} or {variable_value} is not defined in the {full_path}")
        else:
            for idx, path_element in enumerate(path_elements):
                if isinstance(inv_element, dict) and idx + 1 == len(path_elements):
                    # Since this is last path element, verify if element or element_variable exists in the path
                    global_value = path_element
                    variable_value = global_value + "_variable"
                    if global_value not in inv_element and variable_value not in inv_element:
                        results.append(f"Required parameter {global_value} or {variable_value} is not defined in the {full_path}")
                elif isinstance(inv_element, dict):
                    inv_element = inv_element.get(path_element)
                    full_path += path_element if not full_path else "." + path_element
                elif isinstance(inv_element, list):
                    for idx2, i in enumerate(inv_element):
                        r = cls.match_path(i, full_path + f"[{i['name']}]" if isinstance(i, dict) and "name" in i else full_path + f"[{idx2}]", ".".join(path_elements[idx:]))
                        results.extend(r)
                    return results
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            r = cls.match_path(inventory, '', path)
            results.extend(r)
        return results
