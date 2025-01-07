class Rule:
    id = "405"
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
                        
        return results
