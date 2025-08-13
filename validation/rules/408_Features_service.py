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
        return results
