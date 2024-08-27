class Rule:
    id = "408"
    description = "Validate trackers"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("service_profiles", []):
            for tracker in feature_profile.get("ipv4_trackers", []):
                if ("endpoint_protocol" in tracker or "endpoint_protocol_variable" in tracker) and "endpoint_ip" not in tracker and "endpoint_ip_variable" not in tracker:
                    results.append(f'Parameter endpoint_protocol/endpoint_protocol_variable is defined but endpoint_ip/endpoint_ip_variable is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile["name"]}].ipv4_trackers[{tracker["name"]}]')
                if ("endpoint_port" in tracker or "endpoint_port_variable" in tracker) and "endpoint_ip" not in tracker and "endpoint_ip_variable" not in tracker:
                    results.append(f'Parameter endpoint_port/endpoint_port_variable is defined but endpoint_ip/endpoint_ip_variable is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile["name"]}].ipv4_trackers[{tracker["name"]}]')
                if ("endpoint_protocol" in tracker or "endpoint_protocol_variable" in tracker) and "endpoint_port" not in tracker and "endpoint_port_variable" not in tracker:
                    results.append(f'Parameter endpoint_protocol/endpoint_protocol_variable is defined but endpoint_port/endpoint_port_variable is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile["name"]}].ipv4_trackers[{tracker["name"]}]')
                if ("endpoint_port" in tracker or "endpoint_port_variable" in tracker) and "endpoint_protocol" not in tracker and "endpoint_protocol_variable" not in tracker:
                    results.append(f'Parameter endpoint_port/endpoint_port_variable is defined but endpoint_protocol/endpoint_protocol_variable is not defined in the sdwan.feature_profiles.service_profiles[{feature_profile["name"]}].ipv4_trackers[{tracker["name"]}]')
        return results
        