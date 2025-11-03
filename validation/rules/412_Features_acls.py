class Rule:
    id = "412"
    description = "Validate access lists"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile_type in ["transport_profiles", "service_profiles"]:
            for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get(feature_profile_type, []):
                # For IPv4 ACLS
                for acl in feature_profile.get("ipv4_acls", []):
                    for sequence in acl.get("sequences"):
                        if sequence.get("match_entries", {}).get("icmp_messages"):
                            # If icmp_messages is defined, protocol should be 1 and only 1
                            if not sequence.get("match_entries").get("protocols"):
                                results.append(f"icmp_messages is defined in the sdwan.feature_profiles.{feature_profile_type}['{feature_profile['name']}'].ipv4_acls['{acl['name']}'].sequences['{sequence['id']}'], but protocol 1 is not included in match criterias")
                            else:
                                if sequence.get("match_entries").get("protocols") != [1]:
                                    results.append(f"icmp_messages is defined in the sdwan.feature_profiles.{feature_profile_type}['{feature_profile['name']}'].ipv4_acls['{acl['name']}'].sequences['{sequence['id']}'], but protocols is not set to 1")
                        if sequence.get("base_action") == "drop":
                            # Some actions should not be allowed when base_action is drop
                            invalid_actions = []
                            for action in ["dscp", "ipv4_next_hop", "mirror", "policer"]:
                                if action in sequence.get("actions", {}).keys():
                                    invalid_actions.append(action)
                            if invalid_actions:
                                results.append(f"sdwan.feature_profiles.{feature_profile_type}['{feature_profile['name']}'].ipv4_acls['{acl['name']}'].sequences['{sequence['id']}'] has base_action 'drop' but also has actions: {', '.join(invalid_actions)}")
                # For IPv6 ACLS
                for acl in feature_profile.get("ipv6_acls", []):
                    for sequence in acl.get("sequences"):
                        if sequence.get("base_action") == "drop":
                            # Some actions should not be allowed when base_action is drop
                            valid_actions_v6 = ["log", "counter_name"]
                            for action in sequence.get("actions", {}).keys():
                                if action not in valid_actions_v6:
                                    results.append(f"sdwan.feature_profiles.{feature_profile_type}['{feature_profile['name']}'].ipv6_acls['{acl['name']}'].sequences['{sequence['id']}'] has base_action 'drop' but also has invalid action: {action}")
        return results