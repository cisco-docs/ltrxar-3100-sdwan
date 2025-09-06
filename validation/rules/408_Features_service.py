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
            # Validate lan_vpn feature options
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
                # Check if NAT pools exist
                if not lan_vpn.get("nat_pools") and lan_vpn.get("nat_port_forwards"):
                    results.append(
                        f"nat_port_forward is defined but no NAT pools exist in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}]")
                if not lan_vpn.get("nat_pools") and lan_vpn.get("static_nat_entries"):
                    results.append(
                        f"static_nat is defined but no NAT pools exist in sdwan.feature_profiles.service_profiles[{feature_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}]")                        
        return results
