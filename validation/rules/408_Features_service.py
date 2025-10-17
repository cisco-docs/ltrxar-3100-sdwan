class Rule:
    id = "408"
    description = "Validate service features"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("service_profiles", []):
            # Validate dhcp_servers feature options
            for dhcp_server in feature_profile.get("dhcp_servers", []):
                for index, option in enumerate(dhcp_server.get("options", [])):
                    if all(option.get(key) is None for key in ["hex", "ascii", "ip_addresses"]):
                        results.append(f"dhcp option type (one of: ascii, ip_address, hex) is required, but not defined in the sdwan.feature_profiles.service_profile[{feature_profile['name']}].dhcp_servers[{dhcp_server['name']}].options[{index}]")
            # Validate bgp features
            for bgp in feature_profile.get("bgp_features", []):
                as_number = bgp.get("as_number", "as_number")
                for neighbor_family_type in ["ipv4_neighbors", "ipv6_neighbors"]:
                    for index, neighbor in enumerate(bgp.get(neighbor_family_type, [])):
                        if neighbor.get("local_as", "local_as") == as_number:
                            results.append(f"local_as is the same as as_number {as_number} in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].bgp_features[{bgp['name']}].{neighbor_family_type}[{index}]")
                        # Check for duplicate family_type in neighbor.address_families
                        family_types = [af.get("family_type") for af in neighbor.get("address_families", []) if "family_type" in af]
                        duplicates = set([ft for ft in family_types if family_types.count(ft) > 1])
                        for dup in duplicates:
                            results.append(
                                f"Duplicate family_type '{dup}' found in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].bgp_features[{bgp['name']}].{neighbor_family_type}[{index}].address_families"
                            )
                        # Validate maximum_prefixes_reach_policy
                        for index, address_family in enumerate(neighbor.get("address_families", [])):
                            reach_policy = address_family.get("maximum_prefixes_reach_policy", "off")
                            family_type = address_family.get('family_type')
                            base_path = f"sdwan.feature_profiles.service_profiles[{feature_profile['name']}].bgp_features[{bgp['name']}].{neighbor_family_type}[{index}].address_families[{family_type}]"
                            # Define required and forbidden fields for each policy
                            policy_requirements = {
                                "off": {
                                    "forbidden": [
                                        "maximum_prefixes_number", "maximum_prefixes_number_variable",
                                        "maximum_prefixes_restart_interval", "maximum_prefixes_restart_interval_variable",
                                        "maximum_prefixes_threshold", "maximum_prefixes_threshold_variable"
                                    ],
                                    "required": []
                                },
                                "restart": {
                                    "forbidden": [],
                                    "required": [
                                        ("maximum_prefixes_number", "maximum_prefixes_number_variable"),
                                        ("maximum_prefixes_restart_interval", "maximum_prefixes_restart_interval_variable")
                                    ]
                                },
                                "warning-only": {
                                    "forbidden": [
                                        "maximum_prefixes_restart_interval", "maximum_prefixes_restart_interval_variable"
                                    ],
                                    "required": [
                                        ("maximum_prefixes_number", "maximum_prefixes_number_variable")
                                    ]
                                },
                                "disable-peer": {
                                    "forbidden": [
                                        "maximum_prefixes_restart_interval", "maximum_prefixes_restart_interval_variable"
                                    ],
                                    "required": [
                                        ("maximum_prefixes_number", "maximum_prefixes_number_variable")
                                    ]
                                }
                            }
                            reqs = policy_requirements.get(reach_policy, policy_requirements["off"])
                            # Check forbidden fields
                            for param in reqs["forbidden"]:
                                if param in address_family:
                                    results.append(f"maximum_prefixes_reach_policy is {reach_policy}, but {param} is defined in {base_path}")
                            # Check required fields (at least one of the tuple must be present)
                            for required_group in reqs["required"]:
                                if not any(field in address_family for field in required_group):
                                    results.append(f"maximum_prefixes_reach_policy is {reach_policy}, but {required_group[0]} is not defined in {base_path}")
            # Validate eigrp features
            for eigrp in feature_profile.get("eigrp_features", []):
                # if authentication type is md5, md5_keys must be defined, and key_id/key_id_variable and key_string/key_string_variable must be defined in each md5_key
                if eigrp.get("authentication_type", "none") == "md5":
                    if "md5_keys" not in eigrp:
                        results.append(f"authentication_type is md5 but md5_keys is not defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].eigrp_features[{eigrp['name']}]")
                    else:
                        for index, md5_key in enumerate(eigrp["md5_keys"]):
                            if "key_id" not in md5_key and "key_id_variable" not in md5_key:
                                results.append(f"authentication_type is md5 but key_id is not defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].eigrp_features[{eigrp['name']}]")
                            if "key_string" not in md5_key and "key_string_variable" not in md5_key:
                                results.append(f"authentication_type is md5 but key_string is not defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].eigrp_features[{eigrp['name']}]")
                # if authentication type is hmac-sha-256, hmac_authentication_key/hmac_authentication_key_variable must be defined
                elif eigrp.get("authentication_type", "none") == "hmac-sha-256":
                    if "hmac_authentication_key" not in eigrp and "hmac_authentication_key_variable" not in eigrp:
                        results.append(f"authentication_type is hmac-sha-256 but hmac_authentication_key is not defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].eigrp_features[{eigrp['name']}]")
            # Validate ospf features
            for ospf in feature_profile.get("ospf_features", []):
                if ospf.get("default_originate", False) == False:
                    forbidden_options = ["default_originate_always", "default_originate_always_variable", "default_originate_metric", "default_originate_metric_variable", "default_originate_metric_type", "default_originate_metric_type_variable"]
                    for option in forbidden_options:
                        if option in ospf:
                            results.append(f"default_originate is false, but {option} is defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}]")
                if ospf.get("router_lsa_advertisement_type", "none") != "on-startup" and "router_lsa_advertisement_time" in ospf:
                    results.append(f"router_lsa_advertisement_time is defined but router_lsa_advertisement_type is not set to on-startup in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}]")
                for area_index, area in enumerate(ospf.get("areas", [])):
                    if area.get("number") == 0:
                        forbidden_options = ["type", "no_summary", "no_summary_variable"]
                        for option in forbidden_options:
                            if option in area:
                                results.append(f"area number is 0, but {option} is defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}].areas[{area_index}]")
                    for interface_index, interface in enumerate(area.get("interfaces", [])):
                        if interface.get("authentication_type", "none") == "md5":
                            if "authentication_message_digest_key" not in interface and "authentication_message_digest_key_variable" not in interface:
                                results.append(f"authentication_type is md5 but authentication_message_digest_key is not defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}].areas[{area.get('number', area_index)}].interfaces[{interface.get('name', interface_index)}]")
                            if "authentication_message_digest_key_id" not in interface and "authentication_message_digest_key_id_variable" not in interface:
                                results.append(f"authentication_type is md5 but authentication_message_digest_key_id is not defined in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}].areas[{area.get('number', area_index)}].interfaces[{interface.get('name', interface_index)}]")
                for index, redistribute in enumerate(ospf.get("redistributes", [])):
                    if redistribute.get("protocol") != "omp" and ("translate_rib_metric" in redistribute or "translate_rib_metric_variable" in redistribute):
                        results.append(f"translate_rib_metric is defined but protocol is not set to omp in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}].redistributes[{index}]")
                    if redistribute.get("protocol") != "nat" and ("dia" in redistribute or "dia_variable" in redistribute):
                        results.append(f"dia is defined but protocol is not set to nat in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].ospf_features[{ospf['name']}].redistributes[{index}]")
            # Validate lan_vpns features
            for lan_vpn in feature_profile.get("lan_vpns", []):
                if ("ipv4_primary_dns_address" not in lan_vpn and "ipv4_primary_dns_address_variable" not in lan_vpn) and ("ipv4_secondary_dns_address" in lan_vpn or "ipv4_secondary_dns_address_variable" in lan_vpn):
                    results.append(f"ipv4_secondary_dns_address is defined but ipv4_primary_dns_address is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}]")
                if ("ipv6_primary_dns_address" not in lan_vpn and "ipv6_primary_dns_address_variable" not in lan_vpn) and ("ipv6_secondary_dns_address" in lan_vpn or "ipv6_secondary_dns_address_variable" in lan_vpn):
                    results.append(f"ipv6_secondary_dns_address is defined but ipv6_primary_dns_address is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}]")  
                # Validate ipv4_static_routes
                for index, route in enumerate(lan_vpn.get("ipv4_static_routes", [])):
                    if route.get("gateway", "nexthop") != "nexthop" and ("next_hops" in route or "next_hops_with_tracker" in route):
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nexthop')} in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nexthop" and not ("next_hops" in route or "next_hops_with_tracker" in route):
                        results.append(f"next_hops list is not present but gateway is set to nexthop in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_static_routes[{index}]")
                # Validate ipv6_static_routes
                for index, route in enumerate(lan_vpn.get("ipv6_static_routes", [])):
                    if route.get("gateway", "nexthop") != "nat" and (route.get("nat") or route.get("nat_variable")):
                        results.append(f"nat option is defined but gateway is not set to nat in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nat" and not (route.get("nat") or route.get("nat_variable")):
                        results.append(f"gateway is set to nat but nat option is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") != "nexthop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nexthop')} in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nexthop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nexthop in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_static_routes[{index}]")
                # Check network and aggregate protocols in ipv4_omp_advertise_routes
                for route_index, route in enumerate(lan_vpn.get("ipv4_omp_advertise_routes", [])):
                    protocol = route.get("protocol")
                    if protocol == "network" and "networks" not in route:
                        results.append(
                            f"'networks' attribute is required for protocol 'network' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_omp_advertise_routes[{route_index}]")
                    elif protocol == "aggregate" and "aggregates" not in route:
                        results.append(
                            f"'aggregates' attribute is required for protocol 'aggregate' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_omp_advertise_routes[{route_index}]")
                    elif protocol != "network" and "networks" in route:
                        results.append(
                            f"'networks' attribute is not allowed for protocol '{protocol}' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_omp_advertise_routes[{route_index}]")
                    elif protocol != "aggregate" and "aggregates" in route:
                        results.append(
                            f"'aggregates' attribute is not allowed for protocol '{protocol}' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_omp_advertise_routes[{route_index}]")
                # Check network and aggregate protocols in ipv6_omp_advertise_routes
                for route_index, route in enumerate(lan_vpn.get("ipv6_omp_advertise_routes", [])):
                    protocol = route.get("protocol")
                    if protocol == "network" and "networks" not in route:
                        results.append( f"'networks' attribute is required for protocol 'network' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_omp_advertise_routes[{route_index}]")
                    elif protocol == "aggregate" and "aggregates" not in route:
                        results.append(f"'aggregates' attribute is required for protocol 'aggregate' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_omp_advertise_routes[{route_index}]")
                    elif protocol != "network" and "networks" in route:
                        results.append(f"'networks' attribute is not allowed for protocol '{protocol}' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_omp_advertise_routes[{route_index}]")
                    elif protocol !=  "aggregate" and  "aggregates" in route:
                        results.append(f"'aggregates' attribute is not allowed for protocol '{protocol}' in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv6_omp_advertise_routes[{route_index}]")
                    
                # Validate ethernet interfaces
                for ethernet_interface in lan_vpn.get("ethernet_interfaces", []):
                    if ethernet_interface.get("ipv4_configuration_type", "static") == "static":
                        if "ipv4_address" not in ethernet_interface and "ipv4_address_variable" not in ethernet_interface:
                            results.append(f"ipv4_configuration type is static but ipv4_address is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                        if "ipv4_subnet_mask" not in ethernet_interface and "ipv4_subnet_mask_variable" not in ethernet_interface:
                            results.append(f"ipv4_configuration type is static but ipv4_subnet_mask is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                        if "ipv4_dhcp_distance" in ethernet_interface or "ipv4_dhcp_distance_variable" in ethernet_interface:
                            results.append(f"ipv4_configuration type is static but ipv4_dhcp_distance is defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                    elif ethernet_interface.get("ipv4_configuration_type", "static") == "dynamic":
                        if "ipv4_address" in ethernet_interface or "ipv4_address_variable" in ethernet_interface:
                            results.append(f"ipv4_configuration type is dynamic but static ipv4_address is defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                        if "ipv4_subnet_mask" in ethernet_interface or "ipv4_subnet_mask_variable" in ethernet_interface:
                            results.append(f"ipv4_configuration type is dynamic but static ipv4_subnet_mask is defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                    if "ipv4_secondary_addresses" in ethernet_interface and ethernet_interface.get("ipv4_configuration_type", "static") != "static":
                        results.append(f"ipv4_secondary_addresses is defined but ipv4_configuration type is not static in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                    if ethernet_interface.get("ipv6_configuration_type", "none") == "static":
                        if "ipv6_address" not in ethernet_interface and "ipv6_address_variable" not in ethernet_interface:
                            results.append(f"ipv6_configuration type is static but ipv6_address is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                    if ethernet_interface.get("autonegotiate") and ethernet_interface.get("speed"):
                        results.append(f"autonegotiate is true but speed is defined in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}]")
                    for vrrp_group in ethernet_interface.get("ipv4_vrrp_groups", []):
                        if "tloc_preference_change_value" in vrrp_group and not vrrp_group.get("tloc_preference_change"):
                            results.append(f"tloc_preference_change_value is defined but tloc_preference_change is not present or false in the sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('name', '')}].ipv4_vrrp_groups")
        return results
