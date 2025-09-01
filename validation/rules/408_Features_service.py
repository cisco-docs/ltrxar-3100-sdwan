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
