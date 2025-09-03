class Rule:
    id = "416"
    description = "Validate policy object features"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []

        # Validate application_list feature
        for application_list in inventory.get('sdwan', {}).get('feature_profiles', {}).get("policy_object_profile", {}).get("application_lists", []):
            # Application list must have either applications or application_families configured, always one of those.
            if ("applications" not in application_list and "application_families" not in application_list) or ("applications" in application_list and "application_families" in application_list):
                results.append(f"Application list '{application_list['name']}' must have either applications or application_families configured in the sdwan.feature_profiles.policy_object_profile.application_lists[{application_list['name']}]")
                
        # Validate app_probe_classes feature
        inventory_policy_objects = inventory.get('sdwan', {}).get('feature_profiles', {}).get("policy_object_profile", {})
        for app_probe_class in inventory_policy_objects.get("app_probe_classes", []):
            if app_probe_class.get('forwarding_class', None):
                first_class_match = next((item for item in inventory_policy_objects.get("class_maps", []) if item.get('name') == app_probe_class['forwarding_class']), None)
                if not first_class_match:
                    results.append(f"The forwarding class '{app_probe_class['forwarding_class']}' in app_probe_class '{app_probe_class['name']}' is not defined in sdwan.feature_profiles.policy_object_profile.class_maps")
        
        # Validate Preferred Color Group feature - Tetriary Colors should not be configured without configuring Secondary Colors
        for preferred_color_group in inventory.get('sdwan', {}).get('feature_profiles', {}).get("policy_object_profile", {}).get("preferred_color_groups", []):
            if "tertiary_colors" in preferred_color_group and "secondary_colors" not in preferred_color_group:
                results.append(f"Preferred color group '{preferred_color_group['name']}' has tertiary_colors configured without secondary_colors in sdwan.feature_profiles.policy_object_profile.preferred_color_groups[{preferred_color_group['name']}]")

        return results
