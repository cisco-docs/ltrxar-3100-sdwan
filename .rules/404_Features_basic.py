class Rule:
    id = "404"
    description = "Validate basic feature"
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
        return results
