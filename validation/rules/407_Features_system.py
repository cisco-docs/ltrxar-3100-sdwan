class Rule:
    id = "407"
    description = "Validate system features"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("system_profiles", []):
            basic_feature = feature_profile.get("basic", {})
            if basic_feature:
                if ("geo_fencing_enable" not in basic_feature or basic_feature["geo_fencing_enable"] is False) and "geo_fencing_range" in basic_feature:
                    results.append(f"geo_fencing_range parameter is configured, but geo_fencing_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].basic[{basic_feature.get('name', 'basic')}]")
                if ("geo_fencing_enable" not in basic_feature or basic_feature["geo_fencing_enable"] is False) and "geo_fencing_sms_enable" in basic_feature:
                    results.append(f"geo_fencing_sms_enable parameter is configured, but geo_fencing_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].basic[{basic_feature.get('name', 'basic')}]")
                if ("geo_fencing_sms_enable" not in basic_feature or basic_feature["geo_fencing_sms_enable"] is False) and "geo_fencing_sms_mobile_numbers" in basic_feature:
                    results.append(f"geo_fencing_sms_mobile_numbers parameter is configured, but geo_fencing_sms_enable is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].basic[{basic_feature.get('name', 'basic')}]")
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
            perfmon_feature = feature_profile.get("performance_monitoring", {})
            if perfmon_feature:
                if ("app_perf_monitor_enabled" not in perfmon_feature or perfmon_feature["app_perf_monitor_enabled"] is False) and "app_perf_monitor_app_groups" in perfmon_feature:
                    results.append(f"app_perf_monitor_app_groups parameter is configured, but app_perf_monitor_enabled is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].performance_monitoring")
                if ("monitoring_config_enabled" not in perfmon_feature or perfmon_feature["monitoring_config_enabled"] is False) and "monitoring_config_interval" in perfmon_feature:
                    results.append(f"monitoring_config_interval parameter is configured, but monitoring_config_enabled is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].performance_monitoring")
                if ("event_driven_config_enabled" not in perfmon_feature or perfmon_feature["event_driven_config_enabled"] is False) and "event_driven_events" in perfmon_feature:
                    results.append(f"event_driven_events parameter is configured, but event_driven_config_enabled is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].performance_monitoring")
            snmp_feature = feature_profile.get("snmp", {})
            if snmp_feature:
                view_names = [view["name"] for view in snmp_feature.get("views", [])]
                for index, community in enumerate(snmp_feature.get("communities", [])):
                    if community["view"] not in view_names:
                        results.append(f"View {community['view']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.communities[{index}]")
                group_names = [group["name"] for group in snmp_feature.get("groups", [])]
                for index, group in enumerate(snmp_feature.get("groups", [])):
                    if group["view"] not in view_names:
                        results.append(f"View {group['view']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.groups[{group['name']}]")
                for index, user in enumerate(snmp_feature.get("users", [])):
                    if user["group"] not in group_names:
                        results.append(f"Group {user['group']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.users[{user['name']}]")
                user_names = [user["name"] for user in snmp_feature.get("users", [])]
                user_labels = [community["user_label"] for community in snmp_feature.get("communities", [])]
                for index, trap_server in enumerate(snmp_feature.get("trap_target_servers", [])):
                    if "user" in trap_server.keys() and "user_label" in trap_server.keys():
                        results.append(f"Both user and user_label are defined in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.trap_target_servers[{index}]")
                    elif "user" in trap_server.keys():
                        if trap_server["user"] not in user_names:
                            results.append(f"User {trap_server['user']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.trap_target_servers[{index}]")
                    elif "user_label" in trap_server.keys():
                        if trap_server["user_label"] not in user_labels:
                            results.append(f"User label {trap_server['user_label']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.trap_target_servers[{index}]")

        return results
