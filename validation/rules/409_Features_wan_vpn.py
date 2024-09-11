class Rule:
    id = "409"
    description = "Validate wan vpn configuration feature"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("transport_profiles", []):
            wan_vpn_feature = feature_profile.get("wan_vpn", {})
            if wan_vpn_feature:
                if ("ipv4_primary_dns_address" not in wan_vpn_feature and "ipv4_primary_dns_address_variable" not in wan_vpn_feature) and ("ipv4_secondary_dns_address" in wan_vpn_feature or "ipv4_secondary_dns_address_variable" in wan_vpn_feature):
                    results.append(f"ipv4_secondary_dns_address is defined but ipv4_primary_dns_address is not defined in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn")
            for index, route in enumerate(wan_vpn_feature.get("ipv4_static_routes", {})):
                if route.get("gateway", "nextHop") != "null0" and "administrative_distance" in route or "administrative_distance_variable" in route:
                    results.append(f"administrative_distance is defined but gateway is not null0 in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
                if route.get("gateway", "nextHop") != "nextHop" and "next_hops" in route:
                    results.append(f"next_hops list is present but gateway is set to {route.get('gateway', 'nextHop')} in the sdwan.feature_profiles.transport_profiles[{feature_profile['name']}].wan_vpn.ipv4_static_routes[{index}]")
        return results
