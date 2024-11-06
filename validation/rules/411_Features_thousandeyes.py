class Rule:
    id = "411"
    description = "Validate thousandeyes configuration feature"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("other_profiles", []):
            thousendeyes_feature = feature_profile.get("thousandeyes", {})
            # Verify if VPN ID is defined, then management_ip, management_subnet_mask and agent_default_gateway should be defined as well
            if thousendeyes_feature:
                if ("vpn_id" in thousendeyes_feature or "vpn_id_variable" in thousendeyes_feature) and ("management_ip" not in thousendeyes_feature and "management_ip_variable" not in thousendeyes_feature):
                    results.append(f"vpn_id/vpn_id_variable is defined but management_ip/management_ip_variable is not defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
                if ("vpn_id" in thousendeyes_feature or "vpn_id_variable" in thousendeyes_feature) and ("management_subnet_mask" not in thousendeyes_feature and "management_subnet_mask_variable" not in thousendeyes_feature):
                    results.append(f"vpn_id/vpn_id_variable is defined but management_subnet_mask/management_subnet_mask_variable is not defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
                if ("vpn_id" in thousendeyes_feature or "vpn_id_variable" in thousendeyes_feature) and ("agent_default_gateway" not in thousendeyes_feature and "agent_default_gateway_variable" not in thousendeyes_feature):
                    results.append(f"vpn_id/vpn_id_variable is defined but agent_default_gateway/agent_default_gateway_variable is not defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
            if thousendeyes_feature.get("proxy_type", "none") == "none":
                # If proxy type is none, then static_proxy_host, static_proxy_port, pac_proxy_url should not be defined
                not_allowed_parameters = ["static_proxy_host", "static_proxy_host_variable", "static_proxy_port", "static_proxy_port_variable", "pac_proxy_url", "pac_proxy_url_variable"]
                for parameter in not_allowed_parameters:
                    if parameter in thousendeyes_feature:
                        results.append(f"proxy_type is none but {parameter} is defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
            elif thousendeyes_feature.get("proxy_type", "none") == "static":
                # If proxy type is static, then static_proxy_host, static_proxy_port are required and pac_proxy_url should not be defined
                mandatory_parameters = ["static_proxy_host", "static_proxy_port"]
                for parameter in mandatory_parameters:
                    if parameter not in thousendeyes_feature and parameter + "_variable" not in thousendeyes_feature:
                        results.append(f"proxy_type is static but {parameter} or {parameter}_variable is not defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
                not_allowed_parameters = ["pac_proxy_url", "pac_proxy_url_variable"]
                for parameter in not_allowed_parameters:
                    if parameter in thousendeyes_feature:
                        results.append(f"proxy_type is static but {parameter} is defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
            elif thousendeyes_feature.get("proxy_type", "none") == "pac":
                # If proxy type is pac, then pac_proxy_url is required and static_proxy_host, static_proxy_port should not be defined
                mandatory_parameters = ["pac_proxy_url"]
                for parameter in mandatory_parameters:
                    if parameter not in thousendeyes_feature and parameter + "_variable" not in thousendeyes_feature:
                        results.append(f"proxy_type is pac but {parameter} or {parameter}_variable is not defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")
                not_allowed_parameters = ["static_proxy_host", "static_proxy_host_variable", "static_proxy_port", "static_proxy_port_variable"]
                for parameter in not_allowed_parameters:
                    if parameter in thousendeyes_feature:
                        results.append(f"proxy_type is pac but {parameter} is defined in the sdwan.feature_profiles.other_profiles[{feature_profile['name']}].thousandeyes")

        return results
