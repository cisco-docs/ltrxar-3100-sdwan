class Rule:
    id = "405"
    description = "Validate logging feature"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("system_profiles", []):
            logging_feature = feature_profile.get("logging", {})
            if logging_feature:
              for index, server in enumerate(logging_feature.get("ipv4_servers", [])):
                if ("tls_enable" not in server or server["tls_enable"] is False) and "tls_properties_custom_profile" in server:
                    results.append(f"tls_properties_custom_profile parameter is configured, but tls_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].logging[{logging_feature.get('name', 'logging')}].ipv4_servers[{index}]")
                if ("tls_enable" not in server or server["tls_enable"] is False) and "tls_properties_profile" in server:
                    results.append(f"tls_properties_profile parameter is configured, but tls_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].logging[{logging_feature.get('name', 'logging')}].ipv4_servers[{index}]")
                if ("tls_properties_custom_profile" not in server or server["tls_properties_custom_profile"] is False) and "tls_properties_profile" in server:
                    results.append(f"tls_properties_profile parameter is configured, but tls_properties_custom_profile is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].logging[{logging_feature.get('name', 'logging')}].ipv4_servers[{index}]")
              for index, server in enumerate(logging_feature.get("ipv6_servers", [])):
                if ("tls_enable" not in server or server["tls_enable"] is False) and "tls_properties_custom_profile" in server:
                    results.append(f"tls_properties_custom_profile parameter is configured, but tls_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].logging[{logging_feature.get('name', 'logging')}].ipv6_servers[{index}]")
                if ("tls_enable" not in server or server["tls_enable"] is False) and "tls_properties_profile" in server:
                    results.append(f"tls_properties_profile parameter is configured, but tls_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].logging[{logging_feature.get('name', 'logging')}].ipv6_servers[{index}]")
                if ("tls_properties_custom_profile" not in server or server["tls_properties_custom_profile"] is False) and "tls_properties_profile" in server:
                    results.append(f"tls_properties_profile parameter is configured, but tls_properties_custom_profile is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].logging[{logging_feature.get('name', 'logging')}].ipv6_servers[{index}]")

        return results
