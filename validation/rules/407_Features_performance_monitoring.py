class Rule:
    id = "407"
    description = "Validate performance monitoring configuration feature"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("system_profiles", []):
            perfmon_feature = feature_profile.get("performance_monitoring", {})
            if perfmon_feature:
                if ("app_perf_monitor_enabled" not in perfmon_feature or perfmon_feature["app_perf_monitor_enabled"] is False) and "app_perf_monitor_app_groups" in perfmon_feature:
                    results.append(f"app_perf_monitor_app_groups parameter is configured, but app_perf_monitor_enabled is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].performance_monitoring")
                if ("monitoring_config_enabled" not in perfmon_feature or perfmon_feature["monitoring_config_enabled"] is False) and "monitoring_config_interval" in perfmon_feature:
                    results.append(f"monitoring_config_interval parameter is configured, but monitoring_config_enabled is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].performance_monitoring")
                if ("event_driven_config_enabled" not in perfmon_feature or perfmon_feature["event_driven_config_enabled"] is False) and "event_driven_events" in perfmon_feature:
                    results.append(f"event_driven_events parameter is configured, but event_driven_config_enabled is not true in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].performance_monitoring")
        return results
