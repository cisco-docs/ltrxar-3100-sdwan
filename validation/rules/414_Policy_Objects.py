class Rule:
    id = "414"
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

        return results
