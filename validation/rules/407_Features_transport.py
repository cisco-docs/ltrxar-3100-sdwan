class Rule:
    id = "407"
    description = "Validate transport features"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("transport_profiles", []):
            # Validate management_vpn feature
            management_vpn_feature = feature_profile.get("management_vpn", {})
            if management_vpn_feature:
                if ("ipv4_primary_dns_address" not in management_vpn_feature and "ipv4_primary_dns_address_variable" not in management_vpn_feature) and ("ipv4_secondary_dns_address" in management_vpn_feature or "ipv4_secondary_dns_address_variable" in management_vpn_feature):
                    results.append(f"ipv4_secondary_dns_address is defined but ipv4_primary_dns_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn")
                for index, route in enumerate(management_vpn_feature.get("ipv4_static_routes", {})):
                    if route.get("gateway", "nextHop") != "null0" and "administrative_distance" in route or "administrative_distance_variable" in route:
                        results.append(f"administrative_distance is defined but gateway is not null0 in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nextHop") != "nextHop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nextHop") == "nextHop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nextHop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv4_static_routes[{index}]")
                for index, route in enumerate(management_vpn_feature.get("ipv6_static_routes", {})):
                    if route.get("gateway", "nextHop") != "nat" and route.get("nat"):
                        results.append(f"nat option is defined but gateway is not set to nat in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nextHop") == "nat" and not route.get("nat"):
                        results.append(f"gateway is set to nat but nat option is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nextHop") != "nextHop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nextHop") == "nextHop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nextHop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                for interface in management_vpn_feature.get("ethernet_interfaces", []):
                    if interface.get("ipv4_configuration_type", "static") == "static":
                        if "ipv4_address" not in interface and "ipv4_address_variable" not in interface:
                            results.append(f"ipv4_configuration type is static but ipv4_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
                        if "ipv4_subnet_mask" not in interface and "ipv4_subnet_mask_variable" not in interface:
                            results.append(f"ipv4_configuration type is static but ipv4_subnet_mask is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
                        if "ipv4_dhcp_distance" in interface or "ipv4_dhcp_distance_variable" in interface:
                            results.append(f"ipv4_configuration type is static but ipv4_dhcp_distance is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
                    elif interface.get("ipv4_configuration_type", "static") == "dynamic":
                        if "ipv4_address" in interface or "ipv4_address_variable" in interface:
                            results.append(f"ipv4_configuration type is dynamic but static ipv4_address is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
                        if "ipv4_subnet_mask" in interface or "ipv4_subnet_mask_variable" in interface:
                            results.append(f"ipv4_configuration type is dynamic but static ipv4_subnet_mask is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
                    if "ipv4_secondary_addresses" in interface and interface.get("ipv4_configuration_type", "static") != "static":
                            results.append(f"ipv4_secondary_addresses is defined but ipv4_configuration type is not static in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
                    if interface.get("ipv6_configuration_type", "none") == "static":
                        if "ipv6_address" not in interface and "ipv6_address_variable" not in interface:
                            results.append(f"ipv6_configuration type is static but ipv6_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
            # Validate management_vpn feature
            wan_vpn_feature = feature_profile.get("wan_vpn", {})
            if wan_vpn_feature:
                if ("ipv4_primary_dns_address" not in wan_vpn_feature and "ipv4_primary_dns_address_variable" not in wan_vpn_feature) and ("ipv4_secondary_dns_address" in wan_vpn_feature or "ipv4_secondary_dns_address_variable" in wan_vpn_feature):
                    results.append(f"ipv4_secondary_dns_address is defined but ipv4_primary_dns_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn")
                for index, route in enumerate(wan_vpn_feature.get("ipv4_static_routes", {})):
                    if route.get("gateway", "nextHop") != "null0" and "administrative_distance" in route or "administrative_distance_variable" in route:
                        results.append(f"administrative_distance is defined but gateway is not null0 in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nextHop") != "nextHop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nextHop") == "nextHop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nextHop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                for index, route in enumerate(wan_vpn_feature.get("ipv6_static_routes", {})):
                    if route.get("gateway", "nextHop") != "nat" and route.get("nat"):
                        results.append(f"nat option is defined but gateway is not set to nat in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nextHop") == "nat" and not route.get("nat"):
                        results.append(f"gateway is set to nat but nat option is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nextHop") != "nextHop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nextHop") == "nextHop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nextHop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
        return results
