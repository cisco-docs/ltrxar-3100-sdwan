class Rule:
    id = "406"
    description = "Validate features references"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for service_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("service_profiles", []):
            defined_elements = {}
            feature_types = ["bgp_features", "eigrp_features", "ipv4_trackers", "ipv4_tracker_groups", "route_policies", "object_trackers", "object_tracker_groups", "ospf_features"]
            # Check which elements are defined
            for feature_type in feature_types:
                defined_elements[feature_type] = []
                for element in service_profile.get(feature_type, []):
                    defined_elements[feature_type].append(element["name"])
            # Validate route policy references in bgp_features
            for bgp_feature in service_profile.get("bgp_features", []):
                for ipv4_neighbor in bgp_feature.get("ipv4_neighbors", []):
                    for af in ipv4_neighbor.get("address_families", []):
                        if af.get("route_policy_in") and af["route_policy_in"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_in']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_neighbors[{ipv4_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                        if af.get("route_policy_out") and af["route_policy_out"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_out']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_neighbors[{ipv4_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                if bgp_feature.get("ipv4_table_map_route_policy") and bgp_feature["ipv4_table_map_route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{bgp_feature['ipv4_table_map_route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_table_map_route_policy, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                for redistribute in bgp_feature.get("ipv4_redistributes", []):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_redistributes, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                for ipv6_neighbor in bgp_feature.get("ipv6_neighbors", []):
                    for af in ipv6_neighbor.get("address_families", []):
                        if af.get("route_policy_in") and af["route_policy_in"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_in']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_neighbors[{ipv6_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                        if af.get("route_policy_out") and af["route_policy_out"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_out']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_neighbors[{ipv6_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                if bgp_feature.get("ipv6_table_map_route_policy") and bgp_feature["ipv6_table_map_route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{bgp_feature['ipv6_table_map_route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_table_map_route_policy, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                for redistribute in bgp_feature.get("ipv6_redistributes", []):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_redistributes, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
            # Validate route policy references in eigrp_features
            for eigrp_feature in service_profile.get("eigrp_features", []):
                if eigrp_feature.get("route_policy") and eigrp_feature["route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{eigrp_feature['route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].eigrp_features[{eigrp_feature['name']}].route_policy, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                for index, redistribute in enumerate(eigrp_feature.get("redistributes", [])):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].eigrp_features[{eigrp_feature['name']}].redistributes[{index}], but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
            # Validate route policy references in ospf_features
            for ospf_feature in service_profile.get("ospf_features", []):
                if ospf_feature.get("route_policy") and ospf_feature["route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{ospf_feature['route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].ospf_features[{ospf_feature['name']}].route_policy, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
                for index, redistribute in enumerate(ospf_feature.get("redistributes", [])):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].ospf_features[{ospf_feature['name']}].redistributes[{index}], but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].route_policies")
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
                # Validate tracker references in ethernet interfaces
                for ethernet_interface in lan_vpn.get("ethernet_interfaces", []):
                    if ethernet_interface.get("ipv4_tracker") and ethernet_interface["ipv4_tracker"] not in defined_elements["ipv4_trackers"]:
                        results.append(
                            f"IPv4 Tracker {ethernet_interface['ipv4_tracker']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].ipv4_trackers, "
                            f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('interface_name', '')}].ipv4_tracker")
                    if ethernet_interface.get("ipv4_tracker_group") and ethernet_interface["ipv4_tracker_group"] not in defined_elements["ipv4_tracker_groups"]:
                        results.append(
                            f"IPv4 Tracker Group {ethernet_interface['ipv4_tracker_group']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].ipv4_tracker_groups, "
                            f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('interface_name', '')}].ipv4_tracker_group")
                    for vrrp_group in ethernet_interface.get("ipv4_vrrp_groups", []):
                        for tracking_object in vrrp_group.get("tracking_objects", []):
                            if "tracker_object" in tracking_object:
                                if tracking_object["tracker_object"] not in defined_elements["object_trackers"] and tracking_object["tracker_object"] not in defined_elements["object_tracker_groups"]:
                                    results.append(
                                        f"Object Tracker (Group) {tracking_object['tracker_object']} is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}], "
                                        f"but is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ethernet_interfaces[{ethernet_interface.get('interface_name', '')}].ipv4_vrrp_groups.tracking_objects")
                                            # Validate BGP reference in WAN VPN
                # Validate routing protocol references
                attached_bgp = lan_vpn.get("bgp", {})
                if attached_bgp and attached_bgp not in defined_elements["bgp_features"]:
                    results.append(f"BGP feature '{attached_bgp}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].bgp, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].bgp_features")
                attached_eigrp = lan_vpn.get("eigrp", {})
                if attached_eigrp and attached_eigrp not in defined_elements["eigrp_features"]:
                    results.append(f"EIGRP feature '{attached_eigrp}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].eigrp, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].eigrp_features")
                attached_ospf = lan_vpn.get("ospf", {})
                if attached_ospf and attached_ospf not in defined_elements["ospf_features"]:
                    results.append(f"OSPF feature '{attached_ospf}' is referenced in sdwan.feature_profiles.service_profiles[{service_profile['name']}].lan_vpns[{lan_vpn.get('name', '')}].ospf, but is not defined in sdwan.feature_profiles.service_profiles[{service_profile['name']}].ospf_features")
        # Validate transport profiles
        for transport_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("transport_profiles", []):
            defined_elements = {}
            feature_types = ["bgp_features", "ipv4_trackers", "ipv4_tracker_groups", "ipv6_trackers", "ipv6_tracker_groups", "ospf_features", "route_policies"]
            # Check which elements are defined
            for feature_type in feature_types:
                defined_elements[feature_type] = []
                for element in transport_profile.get(feature_type, []):
                    defined_elements[feature_type].append(element["name"])
            # Validate route policy references in bgp_features
            for bgp_feature in transport_profile.get("bgp_features", []):
                for ipv4_neighbor in bgp_feature.get("ipv4_neighbors", []):
                    for af in ipv4_neighbor.get("address_families", []):
                        if af.get("route_policy_in") and af["route_policy_in"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_in']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_neighbors[{ipv4_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                        if af.get("route_policy_out") and af["route_policy_out"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_out']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_neighbors[{ipv4_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                if bgp_feature.get("ipv4_table_map_route_policy") and bgp_feature["ipv4_table_map_route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{bgp_feature['ipv4_table_map_route_policy']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_table_map_route_policy, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                for redistribute in bgp_feature.get("ipv4_redistributes", []):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv4_redistributes, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                for ipv6_neighbor in bgp_feature.get("ipv6_neighbors", []):
                    for af in ipv6_neighbor.get("address_families", []):
                        if af.get("route_policy_in") and af["route_policy_in"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_in']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_neighbors[{ipv6_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                        if af.get("route_policy_out") and af["route_policy_out"] not in defined_elements["route_policies"]:
                            results.append(f"Route policy '{af['route_policy_out']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_neighbors[{ipv6_neighbor['name']}].address_families, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                if bgp_feature.get("ipv6_table_map_route_policy") and bgp_feature["ipv6_table_map_route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{bgp_feature['ipv6_table_map_route_policy']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_table_map_route_policy, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                for redistribute in bgp_feature.get("ipv6_redistributes", []):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features[{bgp_feature['name']}].ipv6_redistributes, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
            # Validate route policy references in ospf_features
            for ospf_feature in transport_profile.get("ospf_features", []):
                if ospf_feature.get("route_policy") and ospf_feature["route_policy"] not in defined_elements["route_policies"]:
                    results.append(f"Route policy '{ospf_feature['route_policy']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].ospf_features[{ospf_feature['name']}].route_policy, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
                for index, redistribute in enumerate(ospf_feature.get("redistributes", [])):
                    if redistribute.get("route_policy") and redistribute["route_policy"] not in defined_elements["route_policies"]:
                        results.append(f"Route policy '{redistribute['route_policy']}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].ospf_features[{ospf_feature['name']}].redistributes[{index}], but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].route_policies")
            # Validate references in wan_vpn
            wan_vpn = transport_profile.get("wan_vpn", {})
            if wan_vpn:
                # Validate BGP reference in WAN VPN
                attached_bgp = wan_vpn.get("bgp", {})
                if attached_bgp and attached_bgp not in defined_elements["bgp_features"]:
                    results.append(f"BGP feature '{attached_bgp}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].wan_vpn.bgp, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].bgp_features")
                # Validate OSPF reference in WAN VPN
                attached_ospf = wan_vpn.get("ospf", {})
                if attached_ospf and attached_ospf not in defined_elements["ospf_features"]:
                    results.append(f"OSPF feature '{attached_ospf}' is referenced in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].wan_vpn.ospf, but is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].ospf_features")
            # Validate references in wan_vpn ethernet interfaces
            for interface in transport_profile.get("wan_vpn", {}).get("ethernet_interfaces", []):
                for feature_type in feature_types:
                    if interface.get(feature_type) and interface.get(feature_type) not in defined_elements[feature_type]:
                        results.append(f"{feature_type} {interface.get(feature_type)} is not defined in sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].{feature_type}s, but is referenced in the sdwan.feature_profiles.transport_profiles[{transport_profile['name']}].wan_vpn.ethernet_interfaces[{interface['name']}]")
        return results