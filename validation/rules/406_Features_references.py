class Rule:
    id = "406"
    description = "Validate features references"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        defined_elements = {}
        for transport_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("transport_profiles", []):
            feature_types = ["ipv4_tracker", "ipv4_tracker_group", "ipv6_tracker", "ipv6_tracker_group"]
            # Check which elements are defined
            for feature_type in feature_types:
                defined_elements[feature_type] = []
                for element in transport_profile.get(f"{feature_type}s", []):
                    defined_elements[feature_type].append(element["name"])
            # Validate references in wan_vpn ethernet interfaces
            for interface in transport_profile.get("wan_vpn", {}).get("ethernet_interfaces", []):
                for feature_type in feature_types:  
                    if interface.get(feature_type) and interface.get(feature_type) not in defined_elements[feature_type]:
                        results.append(f"{feature_type} {interface.get(feature_type)} is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].{feature_type}s, but is referenced in the sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].wan_vpn.ethernet_interfaces[{interface['name']}]")
        # Service profiles references check
        for service_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("service_profiles", []):
            defined_elements = {}
            feature_types = ["ipv4_trackers", "ipv4_tracker_groups", "route_policies", "object_trackers", "object_tracker_groups"]
            for feature_type in feature_types:
                defined_elements[feature_type] = []
                for element in service_profile.get(f"{feature_type}", []):
                    defined_elements[feature_type].append(element["name"]) 
            for lan_vpn in service_profile.get("lan_vpns", []):
                # Validate tracker references in lan_vpns static routes 
                for route in lan_vpn.get("ipv4_static_routes", []):
                    for nh in route.get("next_hops_with_tracker", []):
                        if nh.get("tracker") and nh.get("tracker") not in defined_elements["ipv4_trackers"] and nh.get("tracker") not in defined_elements["ipv4_tracker_groups"]:
                            results.append(f"IPv4 Tracker (Group) {nh['tracker']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}], but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ipv4_static_routes[{route.get('network_address', '')}].next_hops_with_tracker[{nh.get('address', '')}]")
                # Validate route_policy in OMP advertise routes (IPv4 and IPv6)
                for route_type in ["ipv4_omp_advertise_routes", "ipv6_omp_advertise_routes"]:
                    for protocol in lan_vpn.get(route_type, []):
                        if protocol.get("protocol") in ["network", "aggregate"]:
                            continue
                        if "route_policy" in protocol and protocol["route_policy"] not in defined_elements["route_policies"]:
                            results.append(
                                f"Route Policy {protocol['route_policy']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}], "
                                f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].{route_type}[{protocol.get('protocol', '')}]")
                # Validate route_policy
                for leak_block in ["route_leaks_to_global", "route_leaks_from_global", "route_leaks_from_service"]:
                    for leak in lan_vpn.get(leak_block, []):
                        if "route_policy" in leak and leak["route_policy"] not in defined_elements["route_policies"]:
                            results.append(
                                f"Route Policy {leak['route_policy']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}], "
                                f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].{leak_block}" )
                        for rd in leak.get("redistributions", []):
                            if "route_policy" in rd and rd["route_policy"] not in defined_elements["route_policies"]:
                                results.append(
                                    f"Route Policy {rd['route_policy']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}], "
                                    f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].{leak_block}[redistributions]")   
                # Validate tracker_object (group) references in nat_pools and static_nat
                for tracker_block in ["nat_pools", "static_nat_entries"]:
                    for item in lan_vpn.get(tracker_block, []):
                        if "tracker_object" in item and item["tracker_object"] not in defined_elements["object_trackers"] and item["tracker_object"] not in defined_elements["object_tracker_groups"]:
                            results.append(
                                f"Object Tracker (Group) {item['tracker_object']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}], "
                                f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].{tracker_block}")

        return results