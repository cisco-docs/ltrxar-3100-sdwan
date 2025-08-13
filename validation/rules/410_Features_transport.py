class Rule:
    id = "410"
    description = "Validate transport features"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("transport_profiles", []):
            # Validate cellular_profile feature
            for cellular_profile in feature_profile.get("cellular_profiles", []):
                # If authentication is Enabled: authentication_type, username, and password must be present
                if cellular_profile.get("authentication_enable", False):
                    if not cellular_profile.get("authentication_type"):
                        results.append(f"authentication is enabled, but authentication_type is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].cellular_profiles[{cellular_profile['name']}]")
                    if not cellular_profile.get("profile_username") and not cellular_profile.get("profile_username_variable"):
                        results.append(f"authentication is enabled, but username is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].cellular_profiles[{cellular_profile['name']}]")
                    if not cellular_profile.get("profile_password") and not cellular_profile.get("profile_password_variable"):
                        results.append(f"authentication is enabled, but password is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].cellular_profiles[{cellular_profile['name']}]")
                else:
                    # If authentication is Disabled or not present: authentication_type, username, and password should not be present
                    if cellular_profile.get("authentication_type"):
                        results.append(f"authentication is disabled, but authentication_type is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].cellular_profiles[{cellular_profile['name']}]")
                    if cellular_profile.get("profile_username") or cellular_profile.get("profile_username_variable"):
                        results.append(f"authentication is disabled, but username is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].cellular_profiles[{cellular_profile['name']}]")
                    if cellular_profile.get("profile_password") or cellular_profile.get("profile_password_variable"):
                        results.append(f"authentication is disabled, but password is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].cellular_profiles[{cellular_profile['name']}]")
            # Validate gps feature
            for gps in feature_profile.get("gps_features", []):
                if not gps.get("nmea_enable"):
                    if gps.get("nmea_source_address") or gps.get("nmea_destination_address") or gps.get("nmea_destination_port"):
                        results.append(f"nmea is disabled, but nmea_source_address, nmea_destination_address or nmea_destination_port is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].gps[{gps['name']}]")
            # Validate management_vpn feature
            management_vpn_feature = feature_profile.get("management_vpn", {})
            if management_vpn_feature:
                if ("ipv4_primary_dns_address" not in management_vpn_feature and "ipv4_primary_dns_address_variable" not in management_vpn_feature) and ("ipv4_secondary_dns_address" in management_vpn_feature or "ipv4_secondary_dns_address_variable" in management_vpn_feature):
                    results.append(f"ipv4_secondary_dns_address is defined but ipv4_primary_dns_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn")
                for index, route in enumerate(management_vpn_feature.get("ipv4_static_routes", {})):
                    if route.get("gateway", "nexthop") != "null0" and "administrative_distance" in route or "administrative_distance_variable" in route:
                        results.append(f"administrative_distance is defined but gateway is not null0 in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nexthop") != "nexthop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nexthop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nexthop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv4_static_routes[{index}]")
                for index, route in enumerate(management_vpn_feature.get("ipv6_static_routes", {})):
                    if route.get("gateway", "nexthop") != "nat" and route.get("nat"):
                        results.append(f"nat option is defined but gateway is not set to nat in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nat" and not route.get("nat"):
                        results.append(f"gateway is set to nat but nat option is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") != "nexthop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nexthop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nexthop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn.ipv6_static_routes[{index}]")
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
                    if interface.get("autonegotiate") and interface.get("speed"):
                        results.append(f"autonegotiate is true but speed is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].management_vpn[{management_vpn_feature.get('name', 'management_vpn')}].ethernet_interfaces[{interface.get('name')}]")
            # Validate wan_vpn feature
            wan_vpn_feature = feature_profile.get("wan_vpn", {})
            if wan_vpn_feature:
                if ("ipv4_primary_dns_address" not in wan_vpn_feature and "ipv4_primary_dns_address_variable" not in wan_vpn_feature) and ("ipv4_secondary_dns_address" in wan_vpn_feature or "ipv4_secondary_dns_address_variable" in wan_vpn_feature):
                    results.append(f"ipv4_secondary_dns_address is defined but ipv4_primary_dns_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn")
                for index, route in enumerate(wan_vpn_feature.get("ipv4_static_routes", {})):
                    if route.get("gateway", "nexthop") != "null0" and "administrative_distance" in route or "administrative_distance_variable" in route:
                        results.append(f"administrative_distance is defined but gateway is not null0 in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nexthop") != "nexthop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nexthop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nexthop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                for index, route in enumerate(wan_vpn_feature.get("ipv6_static_routes", {})):
                    if route.get("gateway", "nexthop") != "nat" and route.get("nat"):
                        results.append(f"nat option is defined but gateway is not set to nat in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nat" and not route.get("nat"):
                        results.append(f"gateway is set to nat but nat option is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") != "nexthop" and "next_hops" in route:
                        results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                    if route.get("gateway", "nexthop") == "nexthop" and "next_hops" not in route:
                        results.append(f"next_hops list is not present but gateway is set to nexthop in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv6_static_routes[{index}]")
                for interface in wan_vpn_feature.get("ethernet_interfaces", []):
                    if interface.get("ipv4_configuration_type", "static") == "static":
                        if "ipv4_address" not in interface and "ipv4_address_variable" not in interface:
                            results.append(f"ipv4_configuration type is static but ipv4_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if "ipv4_subnet_mask" not in interface and "ipv4_subnet_mask_variable" not in interface:
                            results.append(f"ipv4_configuration type is static but ipv4_subnet_mask is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if "ipv4_dhcp_distance" in interface or "ipv4_dhcp_distance_variable" in interface:
                            results.append(f"ipv4_configuration type is static but ipv4_dhcp_distance is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    elif interface.get("ipv4_configuration_type", "static") == "dynamic":
                        if "ipv4_address" in interface or "ipv4_address_variable" in interface:
                            results.append(f"ipv4_configuration type is dynamic but static ipv4_address is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if "ipv4_subnet_mask" in interface or "ipv4_subnet_mask_variable" in interface:
                            results.append(f"ipv4_configuration type is dynamic but static ipv4_subnet_mask is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    if "ipv4_secondary_addresses" in interface and interface.get("ipv4_configuration_type", "static") != "static":
                            results.append(f"ipv4_secondary_addresses is defined but ipv4_configuration type is not static in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    if interface.get("ipv6_configuration_type", "none") == "static":
                        if "ipv6_address" not in interface and "ipv6_address_variable" not in interface:
                            results.append(f"ipv6_configuration type is static but ipv6_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    if interface.get("adaptive_qos", False) == False:
                        if interface.get("adaptive_qos_period") or interface.get("adaptive_qos_period_variable"):
                            results.append(f"adaptive_qos is false but adaptive_qos_period is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if interface.get("adaptive_qos_shaping_rate_downstream"):
                            results.append(f"adaptive_qos is false but adaptive_qos_shaping_rate_downstream is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if interface.get("adaptive_qos_shaping_rate_upstream"):
                            results.append(f"adaptive_qos is false but adaptive_qos_shaping_rate_upstream is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    if interface.get("ipv4_nat", False) == False:
                        for key in interface.keys():
                            if key.startswith("ipv4_nat_"):
                                results.append(f"ipv4_nat is false but {key} is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    else:
                        if (interface.get("ipv4_nat_loopback_interface") or interface.get("ipv4_nat_loopback_interface_variable")) and interface.get("ipv4_nat_type", "inteface") != "loopback":
                            results.append(f"ipv4_nat_loopback_interface is defined but ipv4_nat_type is not loopback in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        nat_pool_parameters = ["ipv4_nat_pool_overload", "ipv4_nat_pool_overload_variable", "ipv4_nat_pool_prefix_length", "ipv4_nat_pool_prefix_length_variable", "ipv4_nat_pool_range_end", "ipv4_nat_pool_range_end_variable", "ipv4_nat_pool_range_start", "ipv4_nat_pool_range_start_variable"]
                        for parameter in nat_pool_parameters:
                            if interface.get(parameter) and interface.get("ipv4_nat_type", "inteface") != "pool":
                                results.append(f"{parameter} is defined but ipv4_nat_type is not pool in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    if interface.get("ipv6_nat", False) == False:
                        for key in interface.keys():
                            if key.startswith("ipv6_nat") or key.startswith("ipv6_nat66"):
                                results.append(f"ipv6_nat is false but {key} is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    if interface.get("autonegotiate") and interface.get("speed"):
                        results.append(f"autonegotiate is true but speed is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                    tunnel_interface = interface.get("tunnel_interface", {})
                    if tunnel_interface:
                        if tunnel_interface.get("gre_encapsulation", False) == False:
                            if tunnel_interface.get("gre_preference") or tunnel_interface.get("gre_preference_variable"):
                                results.append(f"gre_encapsulation is false but gre_preference is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                            if tunnel_interface.get("gre_weight") or tunnel_interface.get("gre_weight_variable"):
                                results.append(f"gre_encapsulation is false but gre_weight is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if tunnel_interface.get("ipsec_encapsulation", True) == False:
                            if tunnel_interface.get("ipsec_preference") or tunnel_interface.get("ipsec_preference_variable"):
                                results.append(f"ipsec_encapsulation is false but ipsec_preference is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                            if tunnel_interface.get("ipsec_weight") or tunnel_interface.get("ipsec_weight_variable"):
                                results.append(f"ipsec_encapsulation is false but ipsec_weight is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        if tunnel_interface.get("per_tunnel_qos", False) == False:
                            if tunnel_interface.get("per_tunnel_qos_mode") or tunnel_interface.get("per_tunnel_qos_mode_variable"):
                                results.append(f"per_tunnel_qos is false but per_tunnel_qos_mode is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                            if tunnel_interface.get("per_tunnel_qos_bandwidth_percent") or tunnel_interface.get("per_tunnel_qos_bandwidth_percent_variable"):
                                results.append(f"per_tunnel_qos is false but per_tunnel_qos_bandwidth_percent is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                            if tunnel_interface.get("per_tunnel_qos_bandwidth_percent") and tunnel_interface.get("per_tunnel_qos_mode") != "hub":
                                results.append(f"per_tunnel_qos_bandwidth_percent is defined but per_tunnel_qos_mode is not hub in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
                        else:
                            if tunnel_interface.get("per_tunnel_qos_mode") and interface.get("adaptive_qos"):
                                results.append(f"Mutually exclusive parameters tunnel_interface.per_tunnel_qos_mode and adaptive_qos are is defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ethernet_interfaces[{interface.get('name')}]")
        return results
